"""
The file port.conf to be generated looks like:

1=4x10G
2=4x10G
3=4x10G
4=40G
"""

def print_portconf(list):
    ports = {}
    for intf in list:
        intnum = intf.lstrip("swp")
        if 's' in intnum:
            ports[intnum.split('s')[0]]="4x10G"
        else:
            ports[intnum]="40G"
    output = ""
    for key,value in ports.iteritems():
        output = output + "{}={}\n".format(key,value)
    return output

class FilterModule(object):
    ''' A filter to fix interface's name format '''
    def filters(self):
        return {
            'print_portconf': print_portconf
        }
