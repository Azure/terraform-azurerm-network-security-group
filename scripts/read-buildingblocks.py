import json
import string

file =  open('nsg.json', 'r')
output_file = open ('protocols', 'w')

data = json.load(file)

for idx, val in (enumerate(data)):
    print("#%s" % val, file=output_file)
    print("#%s" % val)

    for ruleid, rules in (enumerate(data[val])):
        if len(data[val]) == 1:
            shortname = val
        else:
            shortname = val + "-" + rules['name']
        print ("%s=[\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",]" % (shortname, rules['direction'], rules['access'], rules['protocol'], rules['sourcePortRange'], rules['destinationPortRange'], rules['name']), file= output_file)
        print ("%s=[\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",]" % (shortname, rules['direction'], rules['access'], rules['protocol'], rules['sourcePortRange'], rules['destinationPortRange'], rules['name']))


# [direction, access, protocol, source_port_range, destination_port_range, description]"
#  ad-389-tcp = ["Inbound", "Allow", "*", "*", "389", "Allow AD Replication"]
