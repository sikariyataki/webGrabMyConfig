#!/bin/bash

CDIR=`pwd`

echo "#!/bin/bash
export LD_LIBRARY_PATH="$CDIR"
"$CDIR"/XmltvGUI -ns" > "xmltv.sh" 
  chmod 755 "xmltv.sh"

echo "#!/bin/bash
export LD_LIBRARY_PATH="$CDIR"
"$CDIR"/XmltvGUI /Grab -ns" > "grab.sh" 
  chmod 755 "grab.sh"

echo "#!/bin/bash
export LD_LIBRARY_PATH="$CDIR"
"$CDIR"/XmltvGUI /Grab /Silent -ns" > "grab_silent.sh" 
  chmod 755 "grab_silent.sh"

echo "#!/bin/bash
export LD_LIBRARY_PATH="$CDIR"
"$CDIR"/XmltvConsole" > "grab_console.sh" 
  chmod 755 "grab_console.sh"

exit 0 
