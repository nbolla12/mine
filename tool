import sys
import os
import re
import webbrowser
import easygui
import itertools
import time
import inspect

directry = ['New Folder','Stripped_Txt_files','Differ_Html_files']

def Set_html_file():
	
	#open the diff text anfd html file
	txt_fp = open(drive+'New Folder\\updatd_text.txt')
	html_fp = open(drive+'New Folder\\updated.2.ada.html')
	#Create new temp files
	fp_wr = open(drive+'New Folder\\changed_html.2.ada.html','w')
	fp_wr.close()
	fp_wr = open(drive+'New Folder\\changed_html.2.ada.html','a+')
	
	#Updating the html code for updated function
	#reading the two lines at time from both text and html file
	for i,(txt_buff,html_buff) in enumerate(itertools.izip(txt_fp,html_fp)):
		
		# updating html file for newly added lines in code
		if '+++|\n' in txt_buff or '  +|\n' in txt_buff:
			html_buff = html_buff+'<spam style="background-color:Yellow">'+'\n'
			fp_wr.write(html_buff)
			
		#end if
		# updating html file for newly updated functions, variables in code
		elif '+++' in txt_buff or '  +' in txt_buff:	
			if "color:#009900" in html_buff :
				html_buff1 =html_buff[:36]+'<spam style="background-color:Yellow">'+ html_buff[36:]
				fp_wr.write(html_buff1)
				
			elif ("color:#FF0000" in html_buff):
				html_buff1 =html_buff[:36]+ '<spam style="background-color:aqua">'+ html_buff[36:]
				fp_wr.write(html_buff1)
			
			else:
				html_buff3 = html_buff[:13]+'<spam style="background-color:LightYellow">'+html_buff[13:]
				fp_wr.write(html_buff3)
		else:
			fp_wr.write(html_buff)
	#End for
	#Close all file pointers
	fp_wr.close()
	txt_fp.close()
	html_fp.close()
#End for

# For creating the directories 
############################################################################
#############################################################################
############### START OF THE CODE ##########################################
############################################################################

# user interaction to create the folders to save resulted files
choices = easygui.ccbox(msg=" Do you want to create the below folders in selected drive\n 1.    New Folder\n 2.    Stripped_Txt_files \n 3.    Differ_Html_files \n  "
    , title="   ATTENSION  "
    , choices=("Create", "Already Created")
    , image=None
    )
#Condition to create folders
if (choices):
		
	drive= easygui.diropenbox(msg=" Select the drive to save files", title=None,default="C:\\")
	if len(drive) != 3:
		drive = drive+"\\"
		
	#Condition to create folders
	for new_dir in directry:
		if not os.path.exists(drive+new_dir):
			os.makedirs(drive+new_dir)
		else:
			print "############### ALREADY CREATED ##########################################"
	#End for
else:
	drive = "C:\\"
	#checking the wether the created folders are in the C drive
	for new_dir in directry:
		if not os.path.exists(drive+new_dir):
			os.makedirs(drive+new_dir)
		else:
			print "############### ALREADY CREATED ##########################################"

#End if	
choice =1

# 
while(choice):

	# Open the html file
	html_file =easygui.fileopenbox(	msg="Open the differ HTML file", 
														title=None, default="*", filetypes='.html')
														
	head, tail = os.path.split(html_file)													
														

	fp_html= open(html_file)
	
	#Size of html file
	size_orgnl = len(fp_html.readlines( ))
	fp_html.close()
	
	# Open the html file
	fp_html= open(html_file)

	#Create new html file
	fw= open(drive+'New Folder\\updated.2.ada.html','w')
	fw.close()
	fw= open(drive+'New Folder\\updated.2.ada.html','a+')
	start_lines=[]
	end_lines=[]
	#Stripping the first 3 and last 5 lines in the html  file
	for i,dat in map(None,(range(size_orgnl)) ,fp_html.xreadlines( )):
		if i<3 :
			start_lines.append(dat)
		elif i<(size_orgnl-5):
			fw.write(dat)
		else:
			end_lines.append(dat)
		#End if else
	#end for
	#file poienter close
	fp_html.close()
	fw.close()

	fp_html= open(drive+'New Folder\\updated.2.ada.html')
	#Size of html file
	size_html = len(fp_html.readlines( ))
	fp_html.close()

	# Open the difference text file
	difer_txt_file = easygui.fileopenbox(	msg= " \n \n\n \n \n \n \n \n The Selected HTML file : "+tail, 
														title="Open the differ TXT file", default="*", filetypes='.txt')
														
	head, tail2 = os.path.split(difer_txt_file)

	tail2 =tail2.replace('.txt','_strip.txt')

	fil = open(difer_txt_file)

	# copy the diffrence text file to new file (removing deleted line)
	x=[]
	filew = open(drive+"Stripped_Txt_files\\"+tail2,'w')
	filew.close()
	filew = open(drive+"Stripped_Txt_files\\"+tail2,'a+')

	for line in fil.xreadlines():
		if ( ('---' in line[:3] or  '--' in line[:3] or '-' in line[:3])):
			continue
		else:
			filew.write(line)
	#end for
	
	filew.close()
	fil.close()
	
	#open the newly updated text file
	fil = open(drive+"Stripped_Txt_files\\"+tail2)
	#find the size of text file
	size = len(fil.readlines( ))
	fil.close()
	
	fil_differ = open(drive+"Stripped_Txt_files\\"+tail2)
	#Create the new text file
	fp_txt= open(drive+'New Folder\\updatd_text.txt','w')
	fp_txt.close()
	fp_txt= open(drive+'New Folder\\updatd_text.txt','a+')
	
	# skipping the first 4 and last 1 line from the difference text file and saving into the new file
	for ll in itertools.islice(fil_differ, 3, (size-1)):
		fp_txt.write(ll)
	#Close
	fp_txt.close()
	fil_differ.close()
	# open newly created diff text file
	fp_text= open(drive+'New Folder\\updatd_text.txt')

	#Size of diffrenece text file
	size_txt = len(fp_text.readlines( ))

	fp_text.close()
	
	#Get the current exe directory to get the image
	folder = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
	if (size_html != size_txt):
		choice = easygui.buttonbox(msg="The Size of "+tail+" file is not matching with "+tail2+"", 
									title="", choices=["Exit"], 
									image=folder+'\\apo.gif',root=None)
									
		if choice == "Exit":
			print ""
			print " ********* Exited from the function ********** "
			print ""
			sys.exit()
		
	else:
		# updating the html file for updated lines in html file
		Set_html_file()
	#End if
	
	#File operations
	fp_html.close()
	
	fp_html = open(drive+'New Folder\\changed_html.2.ada.html')
	#Size of html file
	size_compres = len(fp_html.readlines( ))
	fp_html.close()
	
	fp_html = open(drive+'New Folder\\changed_html.2.ada.html')

	fp = open(drive+'New Folder\\New_html.2.ada.html','w')

	for i,txt in map(None,(range(size_compres)) ,fp_html.xreadlines( )):
		line_num=str(i+1).zfill(4)
		
		if "style=" in txt:
			txt = txt[:36]+line_num+'&nbsp;&nbsp;&nbsp;&nbsp;'+txt[36:]
		elif len(txt) is 13:
			txt = txt[:7]+line_num+'&nbsp;&nbsp;&nbsp;&nbsp;'+txt[7:]
		else:
			txt = txt[:13]+line_num+'&nbsp;&nbsp;&nbsp;&nbsp;'+txt[13:]
		fp.write(txt)

	fp.close()
	fp_html.close()
	
	tail =tail.replace('.2.ada.html','_diff.2.ada.html')
	fw= open(drive+"Differ_Html_files\\"+tail,'w')
	fw.close()
	fw= open(drive+"Differ_Html_files\\"+tail,'a+')
	
	#adding the skipped first 3 lines to html file
	for i in range (len(start_lines)):
		fw.write(start_lines[i])
	#Close
	
	fp_wr = open(drive+'New Folder\\New_html.2.ada.html')
	
	#adding the updated html data to new file(final resulted file)
	for buf in fp_wr.xreadlines():
		fw.write(buf)
	#End for
	fp_wr.close()
	
	#Adding the skipped last 5 lines to html file
	for i in range (len(end_lines)):
		fw.write(end_lines[i])
	#Close

	fw.close()
	
	#Open the html on browser
	webbrowser.open(drive+"Differ_Html_files\\"+tail,new=1)
	print "==========================================="
	print "The Diffrence text file: "+drive+"Stripped_Txt_files\\"+tail2
	print "The Diffrence html file: "+drive+"Differ_Html_files\\"+tail
	print "==========================================="
	
	#Condition to continue for other files
	choice = easygui.ynbox(msg="Do you want to continue?" , title=" ", choices=("Yes", "No"), image=None )
#End 
    
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	

