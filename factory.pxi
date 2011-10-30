# -*- coding: utf-8
# @Author: Vayn a.k.a. VT <vayn@vayn.de>
# @Name: factory.pxi
# @Date: 2011年 10月 30日 星期日 15:30:18 CST


def query(lang):
  '''
  Produce font object list for the queried language
  '''
  cdef:
    FcChar8 *strpat
    FcPattern *pat = NULL
    FcFontSet *fs = NULL
    FcObjectSet *os = NULL
    list lst = []

  l_lang = (':lang='+lang).encode('utf8')
  strpat = <FcChar8*>(<char*>l_lang)
  pat = FcNameParse(strpat)
  os = FcObjectSetBuild(FC_CHARSET, FC_FILE, NULL)
  fs = FcFontList(<FcConfig*>0, pat, os)
  if fs is NULL or fs.nfont < 1:
    return lst

  cdef:
    int i
    FcChar8 *file
    FcCharSet *cs
  for i in range(fs.nfont):
    if FcPatternGetCharSet(fs.fonts[i], FC_CHARSET, 0, &cs) != Match:
      continue
    if FcPatternGetString(fs.fonts[i], FC_FILE, 0, &file) == Match:
      lst.append(FcFont((<char*>file).decode('utf8')))

  FcPatternDestroy(pat)
  pat = NULL
  FcObjectSetDestroy(os)
  os = NULL
  FcCharSetDestroy(cs)
  cs = NULL
  FcFontSetDestroy(fs)
  fs = NULL
  return lst