#!/usr/bin/python

""" To download Runkeeper data """

# Author: Nitin Jain tachniki@gmail.com

# This code is distributed under GPL3 license http://www.gnu.org/
# licenses/gpl.html. By using this script, you agree to all the
# term and conditions of license. If you don't agree, please don't
# execute this script.

from lxml import html
from datetime import datetime, date, time
import urllib, sgmllib, sys, codecs, string

class runkeeper():
	def getCSVDistTimePace(self,actUrl):
		f = urllib.urlopen(actUrl)
		s = f.read()
		doc = html.fromstring(s)
		csvString=""
		xpat="//div[@id='activityDateText']/text()"

		dt=datetime.strptime(doc.xpath(xpat)[0].lstrip().rstrip().rstrip('::').rstrip(), "%a %b %d %H:%M:%S %Z %Y")

		csvString=csvString+dt.strftime("%m-%d-%Y %H:%M:%S")+", "
		xpat="//div[@id='activityTypeText']/text()"
		csvString=csvString+doc.xpath(xpat)[0]+", "
		xpat="//div[@id='activityStats']/div[@id='statsDistance']/div[@class='mainText']/text()"
		csvString=csvString+doc.xpath(xpat)[0]+", "
		xpat="//div[@id='activityStats']/div[@id='statsDuration']/div[@class='mainText']/text()"
		csvString=csvString+doc.xpath(xpat)[0]+", "
		xpat="//div[@id='activityStats']/div[@id='statsPace']/div[@class='mainText']/text()"
		csvString=csvString+doc.xpath(xpat)[0]+", "
		xpat="//div[@id='activityStats']/div[@id='statsSpeed']/div[@class='mainText']/text()"
		csvString=csvString+doc.xpath(xpat)[0]+", "
		csvString=csvString+actUrl
		return csvString

	def getActivitiesLinks(self,username):
		f=urllib.urlopen("http://runkeeper.com/user/"+username+"/activity")
		s = f.read()
		doc = html.fromstring(s)
		xpat = "//div[@class='monthContainer']/div/div/@link"
		activitiesLink = doc.xpath(xpat)
		return activitiesLink

def main():
	# Getting Runkeeper
	try:
		username = sys.argv[1]
		filename = sys.argv[2]
	except:
		print "\n\n"
		print "#####################################################"
		print "### You must type in format - "
		print "###     " + sys.argv[0] +" <runkeeperUserName> <filename.csv>"
		print "#####################################################"
		print "\n\n"

		sys.exit(2)
	print "\n\n"
	print "#####################################################"
	print "### Start Time:" + datetime.now().strftime("%d-%m-%Y %H:%M:%S")

	rk = runkeeper()
	activitiesLinks = rk.getActivitiesLinks(username)
	lenActivities=len(activitiesLinks)
	if lenActivities < 1 :
		print "#####################################################"
		print "### We didn't find any activities related to this "
		print "### user id. Either user doesn't have any activity "
		print "### or user id is incorrect. Please recheck user id."
		print "#####################################################"
	else :
		print "### This may take long time depending on number of"
		print "### activities. Please have patience . . ."

		print "### Getting " + str(lenActivities) + " activities"
	fullCSVString = "sq no, Date, Activity Type, Distance, Time, Pace, Speed, url\n"
	i=1
	for link in activitiesLinks:
		print "### Getting "+ str(i) + " of "+ str(lenActivities) +" activities"
		activityUrl = "http://runkeeper.com"+link
		fullCSVString = fullCSVString + str(i)+","+rk.getCSVDistTimePace(activityUrl)+"\n"
		i=i+1
	print "### Got " + str(lenActivities) + " activities"
	f = codecs.open(filename,encoding='utf-8', mode='w+')
	f.write (unicode(fullCSVString))
	f.close()
	print "### Wrote the activities to "+ filename
	print "### End Time:" + datetime.now().strftime("%d-%m-%Y %H:%M:%S")
	print "#####################################################"
	print "\n\n"

if __name__=="__main__":
	main()
