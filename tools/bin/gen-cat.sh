#!/bin/bash

ROOTDIR=/opt/docbook

usage()
{
    echo "gen-cat.sh [sgml|xml]"
    exit 0
}

gen_xml_catalog()
{
    CATALOG=$ROOTDIR/tools/xml/catalog.xml

    :> $CATALOG 

    # catalog beginning
    cat >> $CATALOG << EOF
<?xml version="1.0"?>
<!DOCTYPE catalog
   PUBLIC "-//OASIS/DTD Entity Resolution XML Catalog V1.0//EN"
   "http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd">

<catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">

EOF

    ls $ROOTDIR/conf/modules-xml/* | \
    while read mod; do
        if [ -s $mod ]; then
	    while read line; do
	        if [ -f $line ]; then
		    line=${line#`dirname $CATALOG`/}
                    echo "  <nextCatalog  catalog=\"$line\" />" >> $CATALOG
		else
		    echo "Error: $line not found!"
		fi
	    done < $mod
	fi
    done

    # end of catalog
    cat >> $CATALOG << EOF

</catalog>
EOF
}

gen_sgml_catalog()
{
    CATALOG=$ROOTDIR/tools/sgml/catalog.sgml

    :> $CATALOG 

    # catalog beginning
    cat >> $CATALOG << EOF
OVERRIDE YES
SGMLDECL "dtd/docbook-4.5/docbook.dcl"
DTDDECL  "-//OASIS//DTD DocBook XML V4.5CR1//EN"   "decl/xml.dcl"
DTDDECL  "-//OASIS//DTD DocBook XML V4.2//EN"      "decl/xml.dcl"
DTDDECL  "-//OASIS//DTD DocBook XML V3.1//EN"      "decl/xml.dcl"

EOF

    ls $ROOTDIR/conf/modules-sgml/* | \
    while read mod; do
        if [ -s $mod ]; then
	    while read line; do
	        if [ -f $line ]; then
		    line=${line#`dirname $CATALOG`/}
                    echo "CATALOG \"$line\"" >> $CATALOG
		else
		    echo "Error: $line not found!"
		fi
	    done < $mod
	fi
    done
}


if [ $# -eq 0 ]; then 
    usage
fi

while [ $# -gt 0 ]; do
    case $1 in
    xml)
        gen_xml_catalog
	shift
    ;;

    sgml)
        gen_sgml_catalog
	shift
    ;;

    *)
        usage
    ;;
    esac
done

