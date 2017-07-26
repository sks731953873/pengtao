import uuid
import urllib
import httplib
import os
import string
import sys

from time import strftime

def GetNowTime(str_tmp):
	now = strftime("%Y-%m-%d %H:%M:%S")
	return now


def GetMacAddress():
	node = uuid.getnode()
	mac = uuid.UUID(int=node)
	addr = mac.hex[-12:]
	macAddress = ""
	
	for i in range(len(addr)):
		if( i % 2 == 0) and ( i > 0):
			macAddress += ":"
		
		macAddress += addr[i]
		
	return macAddress
	
def GetStationID():
	rlt = ""
	
	if not os.path.isfile("/vault/data_collection/test_station_config/gh_station_info.json"):
		return rlt
		
	file = open("/vault/data_collection/test_station_config/gh_station_info.json")
	str_datas = file.read()	
	str_datas = str_datas.replace('\r','')
	str_datas = str_datas.replace('\n','')
	str_datas = str_datas.replace('\t','')
	str_datas = str_datas.replace('\"','')
	str_datas = str_datas.replace(' ','')
	str_array = str_datas.split(',')
	
	for i in range(0,len(str_array)):
		str_tmp = str_array[i]
		if(str_tmp.startswith("STATION_ID:")):
			str_array = str_tmp.split(':')
			rlt = str_array[1]
			break
    
	file.close()	
	return rlt	

def Get_SFC_URL():
	rlt = ""	
	if not os.path.isfile("/vault/data_collection/test_station_config/gh_station_info.json"):
		return rlt
    
	file = open("/vault/data_collection/test_station_config/gh_station_info.json")
	str_datas = file.read()	
	str_datas = str_datas.replace('\r','')
	str_datas = str_datas.replace('\n','')
	str_datas = str_datas.replace('\t','')
	str_datas = str_datas.replace('\"','')
	str_datas = str_datas.replace(' ','')
	str_array = str_datas.split(',')
	
	for i in range(0,len(str_array)):
		str_tmp = str_array[i]
		if(str_tmp.startswith("SFC_URL:")):
			str_tmp = str_tmp.replace('http://','172.25.3.167/fatpn56')
			str_array = str_tmp.split(':')
			rlt = str_array[1]
			break
    
	file.close()
	return rlt

def QueryMPN_Ren_With_SN(unit_SN):
    print "\n------- Get MPN and Region code From SFC ------"
    print "SN:", unit_SN
    SFC_IP = ""
    SFC_Server = ""
    SFC_URL ="172.25.3.167/fatpn56"
    #Get_SFC_URL()
    if len(SFC_URL) == 0:
        return "The SFC URL is empty."
    
    arr_Tmp = SFC_URL.split('/')

    SFC_IP = arr_Tmp[0]
    SFC_Server = "/" + arr_Tmp[1]
    params="sn="+unit_SN+"&c=QUERY_RECORD"+"&p=region_code"+"&p=mpn"
    #params = urllib.urlencode({'sn': unit_SN, 'c':'QUERY_RECORD','p': "region_code"})
    headers = {"Content-type":"application/x-www-form-urlencoded","Accept":"text/plain"}
    conn = httplib.HTTPConnection(SFC_IP)
    conn.request("POST",SFC_Server,params,headers)
    res = conn.getresponse()
    rlt = res.read()
    print "------- get result:", rlt
    if rlt == "0 SFC_OK RD_ASY=OK":
        return "PASS"
    else:
        return rlt

if __name__ == '__main__':
    #print Get_SFC_URL()
    print QueryMPN_Ren_With_SN(sys.argv[1])