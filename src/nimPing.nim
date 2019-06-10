import os, strutils, net, nativesockets

proc ping*(host: string): bool =
  var hostClean: string
  if isIpAddress(host):
    var ip = parseIpAddress(host)
    hostClean = $ip
  else:
    var hostent: Hostent
    try:
      hostent = getHostByName(host)
    except:
      return false
    if hostent.addrList.len > 0:
      hostClean = $hostent.addrList[0]
    
  when (defined Linux) or (defined Macos):
    result = 0 == execShellCmd("ping -W 1 -c 1 $#" % [hostClean])
  elif defined Windows:
    result = 0 == execShellCmd("ping -w 1 -n 1 $#" % [hostClean])
  else:
    raiseOSError(OSErrorCode(-1), "Os not supported")

when isMainModule:
  assert ping("google.de")
  assert false == ping("asdlkjasldkjasdlkjasdlkjasdlkajsd")
  assert ping("127.0.0.1")
  assert ping("localhost")
  assert false == ping("10.0.0.1")
