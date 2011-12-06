# Example -*- makefile -*- for building a site using DocBook Website
#
# $Id: Makefile-example.txt,v 1.2 2005/04/18 18:58:58 xmldoc Exp $
#
# ------------------------------------------------------------------
# The default value DOCBOOK_WEBSITE below is the canonical URI for
# the current DocBook Website distribution. If you have SGML or
# XML catalogs correctly set up for DocBook Website in your
# environment, and have the DocBook Website distribution installed
# locally on your system, the URI will automatically be resolved
# to the appropriate local path on your system.
# ------------------------------------------------------------------
#                        IMPORTANT!
# ------------------------------------------------------------------
# IF YOU DO NOT HAVE SGML OR XML CATALOGS SET UP ON YOUR SYSTEM,
# change the value of DOCBOOK_WEBSITE to the appropricate local
# pathname for your system. OR, run "make" like this:
#
#  make DOCBOOK_WEBSITE=/foo/bar/website
#
# Note that DOCBOOK_WEBSITE SHOULD NOT BE THE URI FOR YOUR SITE!
# There is nowhere in this makefile where you need to specify that.
# ------------------------------------------------------------------
#

# TOOLS_DIR is the place where Makefile.base and other scripts present.
TOOLS_DIR := /opt/docbook/tools

ifdef XML_CATALOG_FILES
ENSURE_XSL = 
XML_CATALOG_DEFINE = XML_CATALOG_FILES=$(XML_CATALOG_FILES)
else
XML_CATALOG_FILES=$(TOOLS_DIR)/xml/catalog.xml
XML_CATALOG_DEFINE = XML_CATALOG_FILES=$(TOOLS_DIR)/xml/catalog.xml
endif

#DOCBOOK_WEBSITE=http://www.worldhello.net/docbook/xsl/current/website
#DOCBOOK_WEBSITE=http://www.ossxp.com/docbook/xsl/current/website
DOCBOOK_WEBSITE=http://docbook.sourceforge.net/release/website/current

# generate non-tabular output instead of tabular? 1=Yes 0=No
MAKENONTAB ?= 0

# use HTML Tidy to pretty-print HTML? 1=Yes 0=No
USETIDY=0
# specifies how to call tidy
TIDY=tidy
# specifies options to feed to tidy
TIDYOPTS=-iq -latin1 -mn

# specifies command for calling your XSLT engine
# (this default uses Saxon)
#XSLT=java \
#	-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl \
#	-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl \
#	-Djavax.xml.transform.TransformerFactory=com.icl.saxon.TransformerFactoryImpl \
#	com.icl.saxon.StyleSheet \
#	-x org.apache.xml.resolver.tools.ResolvingXMLReader \
#	-y org.apache.xml.resolver.tools.ResolvingXMLReader \
#	-r org.apache.xml.resolver.tools.CatalogResolver

# to use xsltproc as your XSLT engine, either uncomment the next
# line or just run make like this: "make XSLT=xsltproc"
XSLT=xsltproc --nonet 

# XMLPARSER specifies command for calling your preferred XML
# parser for validating the DocBook XML sources for your site
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
XMLPARSER=xmllint --valid --noout --nonet
else
XMLPARSER=java \
	-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl \
	-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl \
	org.apache.xml.resolver.apps.xread
endif

# the following is empty by default; put any custom DocBook
# stylesheet params you want here; they will be applied globally
# to all HTML transformations from your DocBook XML sources
STYLEOPT=

# name of directory to use if chunking output with "make chunk"
DESTPATH=.

# what prefix to use on non-tabular versions HTML files?
NONTABPREFIX=n-

TABSTYLE      =  $(DOCBOOK_WEBSITE)/xsl/tabular.xsl
WEBSTYLE      =  $(DOCBOOK_WEBSITE)/xsl/website.xsl
TABCHUNK      =  $(DOCBOOK_WEBSITE)/xsl/chunk-tabular.xsl
WEBCHUNK      =  $(DOCBOOK_WEBSITE)/xsl/chunk-website.xsl
AUTOLAYOUT    =  $(DOCBOOK_WEBSITE)/xsl/autolayout.xsl 
MAKEDEPENDS   =  $(DOCBOOK_WEBSITE)/xsl/makefile-dep.xsl
MAKETARGETSDB =  $(DOCBOOK_WEBSITE)/xsl/website-targets.xsl

#VERSION_SOURCE = version.xml
#XMLDEPENDS    = autolayout.xml website.database.xml $(VERSION_SOURCE)
XMLDEPENDS    = autolayout.xml website.database.xml

.PHONY : all clean docbook.test install test

all: docbook.test
	$(MAKE) website
	$(MAKE) MAKENONTAB=1 website

ifeq ($(MAKENONTAB),0)
STYLESHEET=$(TABSTYLE)
STYLECHUNK=$(TABCHUNK)
NONTAB_OPT=
-include depends.tabular
else
STYLESHEET=$(WEBSTYLE)
STYLECHUNK=$(WEBCHUNK)
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
NONTAB_OPT= --stringparam filename-prefix $(NONTABPREFIX)
else
NONTAB_OPT= filename-prefix=$(NONTABPREFIX)
endif
-include depends.nontabular
endif

#-include depends.extra

layout.xml:  docbook.test

autolayout.xml: layout.xml | docbook.test
	$(XML_CATALOG_DEFINE) $(XMLPARSER) $(filter-out $(XMLDEPENDS),$^)
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
	$(XML_CATALOG_DEFINE) $(XSLT) $(AUTOLAYOUT) $< > $@
else
	$(XML_CATALOG_DEFINE) $(XSLT) $< $(AUTOLAYOUT) use.extensions=1 > $@
endif

chunk: autolayout.xml
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
	$(XML_CATALOG_DEFINE) $(XSLT) --stringparam output-root $(DESTPATH) $(STYLECHUNK) autolayout.xml
else
	$(XML_CATALOG_DEFINE) $(XSLT) autolayout.xml $(STYLECHUNK) use.extensions=1 output-root=$(DESTPATH)
endif

%.html: autolayout.xml website.database.xml
	$(XML_CATALOG_DEFINE) $(XMLPARSER) $(filter-out $(XMLDEPENDS),$^)
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
	$(XML_CATALOG_DEFINE) $(XSLT) --stringparam output-root $(DESTPATH) $(NONTAB_OPT) $(STYLEOPT) $(STYLESHEET) $(filter-out $(XMLDEPENDS),$^) > $@
else
	$(XML_CATALOG_DEFINE) $(XSLT) output-root=$(DESTPATH) $(filter-out $(XMLDEPENDS),$^) $(STYLESHEET) $(NONTAB_OPT) $(STYLEOPT) use.extensions=1 > $@ 
endif
ifeq ($(USETIDY),1)
	-$(TIDY) -iq -latin1 -mn $@
endif

# RDDL gets its own rule because we never want to call tidy on it
ifeq ($(MAKENONTAB),0)
rddl.html: autolayout.xml
else
$(NONTABPREFIX)rddl.html: autolayout.xml
endif
	$(XML_CATALOG_DEFINE) $(XMLPARSER) $(filter-out $(XMLDEPENDS),$^)
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
	$(XML_CATALOG_DEFINE) $(XSLT) $(NONTAB_OPT) $(STYLEOPT) $(STYLESHEET) $(filter-out $(XMLDEPENDS),$^) > $@
else
	$(XML_CATALOG_DEFINE) $(XSLT) $(filter-out $(XMLDEPENDS),$^) $(STYLESHEET) $(NONTAB_OPT) $(STYLEOPT) use.extensions=1 > $@
endif

depends.tabular depends.nontabular: autolayout.xml
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
	$(XML_CATALOG_DEFINE) $(XSLT) --stringparam output-root $(DESTPATH) --stringparam depends-file $@ $(NONTAB_OPT) $(MAKEDEPENDS) $< > $@
else
	$(XML_CATALOG_DEFINE) $(XSLT) output-root=$(DESTPATH) $< $(MAKEDEPENDS) depends-file=$@ $(NONTAB_OPT) use.extensions=1 > $@
endif

website.database.xml: autolayout.xml
ifeq ($(notdir $(firstword $(XSLT))),xsltproc)
	$(XML_CATALOG_DEFINE) $(XSLT) $(MAKETARGETSDB) $< > $@
else
	$(XML_CATALOG_DEFINE) $(XSLT) $< $(MAKETARGETSDB) use.extensions=1 > $@
endif

ifeq ($(MAKENONTAB),0)
depends: autolayout.xml website.database.xml depends.tabular
else
depends: autolayout.xml website.database.xml depends.nontabular
endif

realclean: clean
ifeq ($(MAKENONTAB),0)
	rm -f autolayout.xml depends.tabular website.database.xml
else
	rm -f autolayout.xml depends.nontabular website.database.xml
endif

docbook.test:
ifeq "$(XML_CATALOG_FILES)" ""
	$(error XML_CATALOG_FILES is blank!)
endif
ifeq "$(origin XML_CATALOG_FILES)" "undefined"
	$(error XML_CATALOG_FILES is $(origin XML_CATALOG_FILES) !)
endif

