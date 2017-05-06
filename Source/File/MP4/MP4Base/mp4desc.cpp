#include "mp4desc.h"
#include <string.h>

//using namespace MPx;
//using namespace MP4;

#ifdef _VONAMESPACE
using namespace _VONAMESPACE;
#endif
//====================================================================

Descriptor* Descriptor::CreateDescriptorByTag(uint8 aTag)
{
#define SW(_t, _c) case _t: return new _c()

	switch (aTag)
	{
	SW(ES_DescrTag, ESDescriptor);
	SW(DecoderConfigDescrTag, DecoderConfigDescriptor);
	SW(DecSpecificInfoTag, DecoderSpecificInfo);
	SW(SLConfigDescrTag, SLConfigDescriptor);
	SW(InitialObjectDescrTag, InitialObjectDescriptor);
	SW(ObjectDescrTag, ObjectDescriptor);
	SW(0x1d, Descriptor); //for DMB
	case 0: //forbidden
		break;
	default: return new DescriptorWithoutChild();
	}
	return 0;

#undef SW
}

Descriptor* Descriptor::Load(Reader& r)
{
	int64 p1 = r.Position();
	Descriptor base;
	if (base.LoadBase(r))
	{
		Descriptor* desc = CreateDescriptorByTag(base.GetTag());
		if (desc)
		{
			desc->Init(base);
			if (desc->LoadExt(r))
			{
				desc->LoadChildren(r);
				return desc;
			}
			delete desc;
		}
	}
	//resotre pointer
	r.SetPosition((ABSPOS)p1);
	return 0;
}

Descriptor* Descriptor::Load(uint8* data, uint32 size)
{
	MemStream ms(data, size);
	ReaderMSB r(&ms);
	return Load(r);
}

//====================================================================

bool Descriptor::ReadMpegSize(Reader& r, uint32& s)
{
	bool b = true;
	s = 0;
	uint8 t;
	uint32 headsize = 1; //tag
	do
	{
		b &= r.Read(&t);
		s <<= 7;
		s |= t & 0x7f;
		++headsize;
		if (headsize > 5)
			return false;
	}
	while ((t & 0x80) && b);
	s += headsize;
	return b;
}

bool Descriptor::WriteMpegSize(Writer& w, uint32 s)
{
	uint8 buf[4];
	s -= 5;
	buf[0] = (uint8) (((s & 0x0fe00000) >> 21) | 0x80);
	buf[1] = (uint8) (((s & 0x0001fc00) >> 14) | 0x80);
	buf[2] = (uint8) (((s & 0x00003f80) >>  7) | 0x80);
	buf[3] = (uint8) (s & 0x7f);
	return w.Write(buf, 4);
}

#ifdef _XMLDUMP

bool Descriptor::Dump(XmlWriter& w) const
{
	const char* tagtext = GetXmlTag();
	bool b = w.StartTag(tagtext);

	b &= DumpBase(w);
	b &= DumpExt(w);

	b &= w.CloseTag();

	b &= DumpChildren(w);

	b &= w.EndTag(tagtext);
	return b;
}

bool Descriptor::DumpBase(XmlWriter& w) const
{
	bool b = w.OutAttribute("tag", tag, "0x%02x");
	b &= w.OutAttribute("addr", GetAddress());
	b &= w.OutAttribute("size", GetSize());
	return b;
}

bool Descriptor::DumpExt(XmlWriter& w) const
{
	return true;
}

#endif //_XMLDUMP

int Descriptor::LoadChildren(Reader& r)
{
	int c = 0;
	int leftsize = int(GetSize() - loadedsize);
	while (leftsize > 0)
	{
		int64 p1 = r.Position();
		Descriptor* b = Load(r);
		if (b == 0)
		{
			SkipLoad(r);
			return c;
		}
		int64 p2 = r.Position();
		leftsize -= int(p2 - p1);
		AddChild(b);
	}
	return c;
}


bool Descriptor::Dump(Writer& w) const
{
	bool b = DumpBase(w);
	b &= DumpExt(w);
	b &= DumpChildren(w);
	return b;
}

bool Descriptor::DumpBase(Writer& w) const
{
	bool b = w.Write(tag);
	b &= WriteMpegSize(w, size);
	return b;
}

bool Descriptor::DumpExt(Writer& w) const
{
	return true;
}

void Descriptor::UpdateSize()
{
	size = CalcBaseSize();
	size += CalcExtSize();
	Descriptor* child = FirstChild();
	while (child)
	{
		child->UpdateSize();
		size += child->GetSize();
		child = NextChild(child);
	}
}

uint32 Descriptor::CalcBaseSize() const
{
	// tag, 1 byte
	// size, 4 bytes
	return 5;
}

uint32 Descriptor::CalcExtSize() const
{
	return 0;
}


Descriptor::Descriptor(uint8 aTag)
: tag(aTag)
{
}

Descriptor::~Descriptor()
{
}

void Descriptor::Init(const Descriptor& b)
{
	SetSize(b.GetSize());
	SetAddress(b.GetAddress());
	tag = b.tag;
	loadedsize = b.loadedsize;
}

bool Descriptor::LoadBase(Reader& r)
{
	int64 p1 = r.Position();
	SetAddress(uint32(p1));
	bool b = r.Read(&tag);
#if 1 //???
	b &= ReadMpegSize(r, size);
#else
	uint8 b8;
	r.Read(&b8);
	size = b8;
	size += 2;  //tag & size byte
#endif
	int64 p2 = r.Position();
	loadedsize = uint32(p2 - p1);
	return b;
}

bool Descriptor::LoadExt(Reader& r)
{
	return true;
}

Descriptor* Descriptor::GetChildByTag(uint8 t)
{
	Descriptor* d = FirstChild();
	while (d)
	{
		if (d->GetTag() == t)
			return d;
		d = NextChild(d);
	}
	return 0;
}

Descriptor* Descriptor::GetChildByIndex(int i)
{
	Descriptor* d = FirstChild();
	int c = 0;
	while (d)
	{
		if (c == i)
			return d;
		d = NextChild(d);
		++c;
	}
	return 0;
}


//====================================================================

UnknownDescriptor::UnknownDescriptor(uint8 aTag)
: Descriptor(aTag),
  bodysize(0)
{
}

UnknownDescriptor::~UnknownDescriptor()
{
	Release();
}

void UnknownDescriptor::Release()
{
	if (bodysize)
	{
		delete[] bodydata;
		bodysize = 0;
	}
}

void UnknownDescriptor::SetBody(uint8* d, uint32 s)
{
	Release();
	bodysize = s;
	bodydata = new uint8[bodysize];
	memcpy(bodydata, d, s);
}

bool UnknownDescriptor::LoadExt(Reader& r)
{
	bool b = true;
	bodysize = GetSize() - loadedsize;
	if (bodysize > 0)
	{
		bodydata = new uint8[bodysize];
		b &= r.Read(bodydata, bodysize);
		loadedsize += bodysize;
	}
	return b;
}

#ifdef _XMLDUMP

bool UnknownDescriptor::DumpExt(XmlWriter& w) const
{
	bool b = w.OutAttribute("bodysize", bodysize);
	w.OutAttributeData("bodydata", bodydata, bodysize);
	return b;
}

#endif //_XMLDUMP


bool UnknownDescriptor::DumpExt(Writer& w) const
{
	if (bodysize == 0)
		return true;
	bool b = w.Write(bodydata, bodysize);
	return b;
}

uint32 UnknownDescriptor::CalcExtSize() const
{
	return bodysize;
}


//====================================================================

ESDescriptor::ESDescriptor()
: Descriptor(ES_DescrTag),
  URLstring(NULL)
{
	URLlength = 0;
	ES_ID = 0;
	streamDependenceFlag = 0;
	URL_Flag = 0;
	OCRstreamFlag = 0;
	streamPriority = 0x10;
}

ESDescriptor::~ESDescriptor()
{
	if (URLstring)
	{
		delete[] URLstring;
		URLstring = NULL;
	}
}

bool ESDescriptor::LoadExt(Reader& r)
{
	int64 p1 = r.Position();
	bool b = r.Read(&ES_ID);
	b &= r.ReadBits(&streamDependenceFlag, 1);
	b &= r.ReadBits(&URL_Flag, 1);
	b &= r.ReadBits(&OCRstreamFlag, 1);
	b &= r.ReadBits(&streamPriority, 5);
	if (streamDependenceFlag)
		b &= r.Read(&dependsOn_ES_ID);
	if (URL_Flag)
	{
		b &= r.Read(&URLlength);
		URLstring = new char[URLlength];
		b &= r.Read(URLstring, URLlength);
	}
#if 1 //test, 1/13/2011
	if (OCRstreamFlag)
		b &= r.Read(&OCR_ES_Id);
#endif //test
	int64 p2 = r.Position();
	loadedsize = uint32(loadedsize +(p2 - p1));
	return b;
}

uint32 ESDescriptor::CalcExtSize() const
{
	uint32 c = 3;
	if (streamDependenceFlag)
		c += 2;
	if (URL_Flag)
		c += URLlength + 1;
	if (OCRstreamFlag)
		c += 2;
	return c;
}

bool ESDescriptor::DumpExt(Writer& w) const
{
	bool b = w.Write(ES_ID);
	b &= w.WriteBits(streamDependenceFlag, 1);
	b &= w.WriteBits(URL_Flag, 1);
	b &= w.WriteBits(OCRstreamFlag, 1);
	b &= w.WriteBits(streamPriority, 5);
	if (streamDependenceFlag)
		b &= w.Write(dependsOn_ES_ID);
	if (URL_Flag)
	{
		b &= w.Write(URLlength);
		b &= w.Write(URLstring, URLlength);
	}
	if (OCRstreamFlag)
		b &= w.Write(OCR_ES_Id);
	return b;
}


bool ESDescriptor::GetDecoderSpecificData(uint8* buf, int* bufsize)
{
	DecoderConfigDescriptor* dcd = (DecoderConfigDescriptor*)
		GetChildByTag(DecoderConfigDescrTag);
	if (dcd == 0)
	{
		*bufsize = 0;
		return false;
	}
	DecoderSpecificInfo* dsi = (DecoderSpecificInfo*)
		dcd->GetChildByTag(DecSpecificInfoTag);
	if (dsi == 0)
	{
		*bufsize = 0;
		return false;
	}
	int size = dsi->GetBodySize();
	bool bOK = false;
	if (*bufsize > size)
	{
		memcpy(buf, dsi->GetBodyData(), size);
		bOK = true;
	}
	*bufsize = size;
	return bOK;
}



#ifdef _XMLDUMP

bool ESDescriptor::DumpExt(XmlWriter& w) const
{
	bool b = w.OutAttribute("ES_ID", ES_ID);
	b &= w.OutAttribute("streamDependenceFlag", streamDependenceFlag);
	b &= w.OutAttribute("URL_Flag", URL_Flag);
	b &= w.OutAttribute("OCRstreamFlag", OCRstreamFlag);
	b &= w.OutAttribute("streamPriority", streamPriority);
	if (streamDependenceFlag)
		b &= w.OutAttribute("dependsOn_ES_ID", dependsOn_ES_ID);
	if (URL_Flag)
		b &= w.OutAttributeText("URLstring", URLstring);
	if (OCRstreamFlag)
		b &= w.OutAttribute("OCR_ES_Id", OCR_ES_Id);
	return b;
}

#endif //_XMLDUMP

//====================================================================

DecoderConfigDescriptor::DecoderConfigDescriptor()
: Descriptor(DecoderConfigDescrTag)
{
}

DecoderConfigDescriptor::~DecoderConfigDescriptor()
{
}

bool DecoderConfigDescriptor::LoadExt(Reader& r)
{
	int64 p1 = r.Position();
	bool b = r.Read(&objectTypeIndication);
	b &= r.ReadBits(&streamType, 6);
	b &= r.ReadBits(&upStream, 1);
	bit1 reserved;
	b &= r.ReadBits(&reserved, 1);
	b &= r.ReadBits(&bufferSizeDB, 24);
	b &= r.Read(&maxBitrate);
	b &= r.Read(&avgBitrate);
	int64 p2 = r.Position();
	loadedsize = uint32(loadedsize +(p2 - p1));
	return b;
}

uint32 DecoderConfigDescriptor::CalcExtSize() const
{
	return 13; //1 + 1 + 3 + 4 + 4;
}

bool DecoderConfigDescriptor::DumpExt(Writer& w) const
{
	bool b = w.Write(objectTypeIndication);
	b &= w.WriteBits(streamType, 6);
	b &= w.WriteBits(upStream, 1);
	b &= w.WriteBits(1, 1); // reserved = 1
	b &= w.WriteBits(bufferSizeDB, 24);
	b &= w.Write(maxBitrate);
	b &= w.Write(avgBitrate);
	return b;
}

#ifdef _XMLDUMP

bool DecoderConfigDescriptor::DumpExt(XmlWriter& w) const
{
	bool b = w.OutAttribute("objectTypeIndication", objectTypeIndication);
	b &= w.OutAttribute("streamType", streamType);
	b &= w.OutAttribute("upStream", upStream);
	b &= w.OutAttribute("bufferSizeDB", bufferSizeDB);
	b &= w.OutAttribute("maxBitrate", maxBitrate);
	b &= w.OutAttribute("avgBitrate", avgBitrate);
	return b;
}

#endif //_XMLDUMP


//====================================================================

SLConfigDescriptor::SLConfigDescriptor()
: Descriptor(SLConfigDescrTag)
{
	predefined = 2;
}

SLConfigDescriptor::~SLConfigDescriptor()
{
}

bool SLConfigDescriptor::LoadExt(Reader& r)
{
	int64 p1 = r.Position();
	bool b = r.Read(&predefined);
	if (predefined)
	{
		loadedsize += 1;
#if 1 //for error-toleratance, we found error size in some files, so we force it no more left size for children. 4/10/2007
		loadedsize = size; 
#endif
		return true; //???
	}
	b &= r.Read(&flags);
	b &= r.Read(&timeStampResolution);
	b &= r.Read(&OCRResolution);
	b &= r.Read(&timeStampLength);
	b &= r.Read(&OCRLength);
	b &= r.Read(&AU_Length);
	b &= r.Read(&instantBitrateLength);
	b &= r.ReadBits(&degradationPriorityLength, 4);
	b &= r.ReadBits(&AU_seqNumLength, 5);
	b &= r.ReadBits(&Packet_SeqNumLength, 5);
	bit2 reserved;
	b &= r.ReadBits(&reserved, 2);
	if (reserved != 3)
		return false;
	if (durationFlag())
		return false;
	if (!useTimeStampsFlag())
		return false;

	int64 p2 = r.Position();
	loadedsize = uint32(loadedsize + (p2 - p1));
	return b;
}

uint32 SLConfigDescriptor::CalcExtSize() const
{
	return predefined ? 1 : 15; //1 + 1 + 4 + 4 + 3 + 2;
}

bool SLConfigDescriptor::DumpExt(Writer& w) const
{
	bool b = w.Write(predefined);
	//TODO
	return b;
}


#ifdef _XMLDUMP

bool SLConfigDescriptor::DumpExt(XmlWriter& w) const
{
	bool b = w.OutAttribute("predefined", predefined);
	if (predefined)
		return true;
	b &= w.OutAttribute("useAccessUnitStartFlag", useAccessUnitStartFlag());
	b &= w.OutAttribute("useAccessUnitEndFlag", useAccessUnitEndFlag());
	b &= w.OutAttribute("useRandomAccessPointFlag", useRandomAccessPointFlag());
	b &= w.OutAttribute("hasRandomAccessUnitsOnlyFlag", hasRandomAccessUnitsOnlyFlag());
	b &= w.OutAttribute("usePaddingFlag", usePaddingFlag());
	b &= w.OutAttribute("useTimeStampsFlag", useTimeStampsFlag());
	b &= w.OutAttribute("useIdleFlag", useIdleFlag());
	b &= w.OutAttribute("durationFlag", durationFlag());
	b &= w.OutAttribute("timeStampResolution", timeStampResolution);
	b &= w.OutAttribute("OCRResolution", OCRResolution);
	b &= w.OutAttribute("timeStampLength", timeStampLength);
	b &= w.OutAttribute("OCRLength", OCRLength);
	b &= w.OutAttribute("AU_Length", AU_Length);
	b &= w.OutAttribute("instantBitrateLength", instantBitrateLength);
	b &= w.OutAttribute("degradationPriorityLength", degradationPriorityLength);
	b &= w.OutAttribute("AU_seqNumLength", AU_seqNumLength);
	b &= w.OutAttribute("Packet_SeqNumLength", Packet_SeqNumLength);
	return b;
}

#endif //_XMLDUMP


//====================================================================

InitialObjectDescriptor::InitialObjectDescriptor()
: Descriptor(InitialObjectDescrTag)
{
}

InitialObjectDescriptor::~InitialObjectDescriptor()
{
}

bool InitialObjectDescriptor::LoadExt(Reader& r)
{
	int64 p1 = r.Position();
	uint8 b1, b2;
    bool b = r.Read(&b1);
	b &= r.Read(&b2);
	ObjectDescriptorID = b1;
	ObjectDescriptorID <<= 2;
	ObjectDescriptorID += b2 >> 6;
	bit1 URL_Flag = b2 & 0x20;
	if (URL_Flag) 
		return false; //not support now

	b &= r.Read(&ODProfileLevelIndication);
	b &= r.Read(&sceneProfileLevelIndication);
	b &= r.Read(&audioProfileLevelIndication);
	b &= r.Read(&visualProfileLevelIndication);
	b &= r.Read(&graphicsProfileLevelIndication);

	int64 p2 = r.Position();
	loadedsize =uint32(loadedsize +(p2 - p1));
	return b;
}

uint32 InitialObjectDescriptor::CalcExtSize() const
{
	return 1;
}

bool InitialObjectDescriptor::DumpExt(Writer& w) const
{
	bool b = true; //TODO
	return b;
}


#ifdef _XMLDUMP

bool InitialObjectDescriptor::DumpExt(XmlWriter& w) const
{
	bool b = w.OutAttribute("ObjectDescriptorID", ObjectDescriptorID);
	return b;
}

#endif //_XMLDUMP


ESDescriptor* InitialObjectDescriptor::FindESD(uint16 esid)
{
	Descriptor* d = FirstChild();
	while (d)
	{
		if (d->GetTag() == ES_DescrTag)
		{
			ESDescriptor* esd = (ESDescriptor*)d;
			if (esd->ES_ID == esid)
				return esd;
		}
		d = NextChild(d);
	}
	return 0;
}

//====================================================================

ObjectDescriptor::ObjectDescriptor()
: Descriptor(ObjectDescrTag)
{
}

ObjectDescriptor::~ObjectDescriptor()
{
}

bool ObjectDescriptor::LoadExt(Reader& r)
{
	int64 p1 = r.Position();
	uint8 b1, b2;
    bool b = r.Read(&b1);
	b &= r.Read(&b2);
	ObjectDescriptorID = b1;
	ObjectDescriptorID <<= 2;
	ObjectDescriptorID += b2 >> 6;
	bit1 URL_Flag = b2 & 0x20;
	if (URL_Flag) 
		return false; //not support now

	int64 p2 = r.Position();
//	loadedsize += p2 - p1;
	loadedsize = uint32(loadedsize +(p2 - p1));
	return b;
}

uint32 ObjectDescriptor::CalcExtSize() const
{
	return 1;
}

bool ObjectDescriptor::DumpExt(Writer& w) const
{
	bool b = true; //TODO
	return b;
}


#ifdef _XMLDUMP

bool ObjectDescriptor::DumpExt(XmlWriter& w) const
{
	bool b = w.OutAttribute("ObjectDescriptorID", ObjectDescriptorID);
	return b;
}

#endif //_XMLDUMP


ESDescriptor* ObjectDescriptor::FindESD(uint16 esid)
{
	Descriptor* d = FirstChild();
	while (d)
	{
		if (d->GetTag() == ES_DescrTag)
		{
			ESDescriptor* esd = (ESDescriptor*)d;
			if (esd->ES_ID == esid)
				return esd;
		}
		d = NextChild(d);
	}
	return 0;
}

//====================================================================
