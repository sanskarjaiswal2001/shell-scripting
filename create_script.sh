#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Please enter script name"
    exit 1
fi
author="Sanskar"
script="$1.sh"
echo "#!/bin/bash" >$script
echo "#Author : $author" >>$script
echo "echo "Pass"" >>$script
chmod +x $script
echo "Script created with name $script"
./$script
