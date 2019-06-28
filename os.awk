#!/bin/awk -f
#os.awk
BEGIN{
FS="#"
os["rh3"]=0
os["rh4"]=0
os["rh5"]=0
os["rh6"]=0
os["suse10"]=0
os["suse11"]=0
}
{
	{if($2~/\<3\>/)
	{os["rh3"]++;
	server["rh3"]=server["rh3"]" "$1
	}
	}
	{if($2~/\<4\>/)
	{os["rh4"]++;
	server["rh4"]=server["rh4"]" "$1
	}
	}
	{if($2~/5/)
	{os["rh5"]++
	server["rh5"]=server["rh5"]" "$1
	}
	}
	{if($2~/6/)
	{os["rh6"]++
	server["rh6"]=server["rh6"]" "$1
	}
	}
	{if($2~/10/)
	{os["suse10"]++
	server["suse10"]=server["suse10"]" "$1
	}
	}
	{if($2~/11/)
	{os["suse11"]++
	server["suse11"]=server["suse11"]" "$1
	}
	}
}
END{
{for (a in os)print a," has",os[a],"servers."}
{for (b in server)print b,"has the below servers:\n",server[b]}
}
