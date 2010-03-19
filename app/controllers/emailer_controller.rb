require 'mysql'
require 'win32ole'
require 'spreadsheet'
class EmailerController < ApplicationController
  layout 'standard'
  def sendmail
      email = params["email"]
	  recipient = email["recipient"]
	  subject = email["subject"]
	  message = email["message"]
    senderid=email["senderid"]
    reportname= email["docname"]
    bugs=email["bug"]
    #generate_report(params[:releaseid],reportname,bugs)
    #puts "Generate REPORT FINISHED"
    #exit
    #~ Emailer.deliver_contact(generate_report(params[:releaseid],reportname,bugs), recipient, subject, message,senderid)
    puts "..........going to send release id #{params[:releaseid]}"
    x= generate_report(params[:releaseid],reportname,bugs)
    if x        
      flash[:notice]="File #{x} saved successfully and can be downloaded.\n\n#{message}" 
    end
    
      #~ return if request.xhr?
      #~ render :text => "Message sent successfully \n\n"
    end
def index 
      @release=Release.find(params[:release_id])
      @bugs = ""
      all=Testreport.find(:all, :conditions=>{:release_id=>params[:release_id].to_i},:include=>'testcase', :order=>'testcases.profile DESC')
      @status=Hash.new()
      @status["pass"]=0
      @status["fail"]=0
      @status["inprogress"]=0
      @status["na"]=0
      @status["block"]=0
      @status["cantrun"]=0
      @status["total"]=0
      @status["pending"]=0
      
      countx=Hash.new(0)
      pcountx=Hash.new(0)
      all.each do |a|
        #~ puts "report bring checked for is #{a.id} AND  + #{a.testcase}"
        if a.result=="PASS"
          @status["pass"]+=1
          #print a.testcase.profile
        elsif a.result=="FAIL"
          @status["fail"]+=1
          elsif a.result=="In Progress"
          @status["inprogress"]+=1
          elsif a.result=="NA"
          @status["na"]+=1
          elsif a.result=="BLOCK"
          @status["block"]+=1
          elsif a.result=="Can Not Run"
          @status["cantrun"]+=1
        end
        #~ puts "Going to increment the count"
          if a.testcase
            countx[a.testcase.profile]+=1
            unless a.result
            pcountx[a.testcase.profile]+=1
          end
          
        end
        #~ puts "Going to check for DEVIATIONS #{a.observation}"
        if a.observation and a.observation.length>1 and !(a.observation.include?("[BugId]:Bug Summary")) and a.result=="FAIL"
         #~ print "\nDeviations #{a.observation}\n\n"
         # @bugs[a.observation.split(":")[0].chomp("]").gsub(/\[/,"")]=a.observation.split(":")[1]
         id=a.observation.split(":")[0].chomp("]").gsub(/\[/,"")? a.observation.split(":")[0].chomp("]").gsub(/\[/,"") : ""
         desc=a.observation.split(":")[1] ? (a.observation.split(":")-a.observation.split(":")[0].to_a).join(":") : ""
         @bugs+=id+":"+desc+"\n"
         
        end
              
      end
      @status["total"]=all.length
      @status["pending"]=@status["total"]-(@status["pass"]+@status["fail"]+@status["na"]+@status["inprogress"]+@status["block"]+@status["cantrun"])
      render :file=>'app\views\emailer\index.rhtml'
end
protected
def generate_report(releaseid,docname,bugs)
  # Returns the entire file path as string
  #~ puts releaseid
  puts "RElease ID received........... #{releaseid}"
  release=Release.find(releaseid.to_i)
  #~ puts ".........release found #{release}"
  #Add APP and WLAN version numbers here

book=Spreadsheet::Workbook.new
 sheet1=book.create_worksheet
  sheet2=book.create_worksheet :name=>'Bug List'
  sheet1.name="Test Cases"
  format = Spreadsheet::Format.new :weight => :bold,
                                   :size => 11
  #format_merged = book.add_format(:align => "merge")
  #~ headingformat = Spreadsheet::Format.new :color=>:yellow,
                                  #~ :weight => :bold,
                                   #~ :size => 11
  #~ default = Spreadsheet::Format.new :size => 20,
                                   #~ :color =>:black,
                                   #~ :weight=>:normal
  #~ blacked_out_format = Spreadsheet::Format.new :pattern_bg_color => "black", :pattern_fg_color => "red", :pattern => 1
   #~ blacked_out_format = Spreadsheet::Format.new  :pattern_bg_color => "red", :pattern => 1
  fail = Spreadsheet::Format.new  :color => "red", :weight=>:bold
  pass = Spreadsheet::Format.new  :color => "green", :weight=>:bold
  cantrun = Spreadsheet::Format.new  :color => "blue", :weight=>:bold
  
  book.add_format fail
  book.add_format pass
  book.add_format cantrun
   book.add_format format
 # book.add_format format_merged
                                   
  

  ms =Mysql.new('localhost','root','gain','testreport_production')
  #~ ms =Mysql.new('localhost','root','gain','testreport_development')
  #select * from testreports left join testcases on testreports.testcase_id=testcases.id where release_id =6 order by testcases.id;
  #rs=ms.query("select testcase_id,build_id, executed_by, deviations, result, observation from testreports where release_id=#{releaseid} order by id")
  #select testreports.testcase_id,testreports.build_id,testreports.executed_by,testreports.deviations,testreports.result,testreports.observation from testreports left join testcases on testreports.testcase_id=testcases.id where release_id =6 order by testcases.id;
  rs=ms.query("select testreports.testcase_id,testreports.build_id, testreports.executed_by, testreports.deviations, testreports.result, testreports.observation from testreports where release_id=#{releaseid} order by testcase_id")
  
  #~ puts "RSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS.......................#{rs}"
  sheet1[0,0]="Release :-#{release.serial}  ,  Test Plan Doc :-#{release.doc}"
  sheet1[1,0]="Start Date of test= #{release.start_date}"
  #sheet1.write(0,10,["Release :-#{release.serial}  ,  Test Plan Doc :-release-test-plan.doc  (version1.17 , cvs/GS1010/ProductTest/doc folder)"],format_merged)
  #sheet1.write()
  sheet1[2,0]="Serial No"
  sheet1[2,1]="Test Case ID"
  #~ sheet1[2,2]="Test Case Profile"
  sheet1[2,2]="Description"
  #~ sheet1[2,4]="Build"
  sheet1[2,3]="Test Engineer"
  sheet1[2,4]="Deviation"
  sheet1[2,5]="Result"
  sheet1[2,6]="Reasons/Observation"
  sheet2[0,0]="Serial No."
  sheet2[0,1]="Bug Id"
  sheet2[0,2]="Bug Description"
  start_row=sheet1.row_count
  i=start_row
  rc=0
  bug_count=sheet2.row_count
  j=bug_count
  testcaselist=Testcase.find(:all)
  buildlist=Build.find(:all)
  rs.each do |r|
    #~ puts "RRRRRRRRRRRRRRRRRRrrrrrrrrrrrr............ #{r[0]}, #{r[1]}"
    namedesc=return_testcaseNdesc(testcaselist,buildlist,r[0].to_i , r[1].to_i)
    #~ puts "##################################################"
    #~ puts namedesc
    #~ puts "##################################################"
    #exit
    sheet1[i,0]=i-start_row+1
    sheet1[i,1]=namedesc["name"]
    #~ sheet1[i,2]=namedesc["profile"]
    sheet1[i,2]=namedesc["description"]
    #~ sheet1[i,4]=namedesc["build"]
    sheet1[i,3]=r[2]
    sheet1[i,4]=r[3]
    sheet1[i,5]=r[4]
    sheet1[i,6]=r[5]
    begin
    print "\n Writing to excel: #{namedesc["name"]} , #{namedesc["profile"]} #{namedesc["description"]}, #{namedesc["build"]},#{r[2]},#{r[3]},#{r[4]},#{r[5]}"
     rescue Exception => err
    puts "Error happened :- #{err}"
    end
    #~ if r[5]
      #~ if r[5].length>1 and r[5].to_s != "[BugId]:Bug Summary" and r[4]!="NA"
        #~ sheet2[j,0]=j-bug_count+1
        #~ sheet2[j,1]=r[5].split(":")[0].chomp("]").gsub(/\[/,"")
        #~ sheet2[j,2]=r[5].split(":")[1]
        #~ j+=1
      #~ end
      
    #~ end
    
    
    i+=1
  end
  bc=1
  if bugs
    bugs.each do |b|
      
      if b.split(":")[0].chomp("]").gsub(/\[/,"").length>1 or b.split(":")[1].chomp!.length>1
      #puts "\n\n..........................Write to excel??? #{b.split(":")[0].chomp("]").gsub(/\[/,"").length} or #{b.split(":")[1].chomp!}............................#{b} \n"
      sheet2[bc,0]=bc
      sheet2[bc,1]=b.split(":")[0].chomp("]").gsub(/\[/,"")
      sheet2[bc,2]=(b.split(":") - b.split(":")[0].to_a).join(":")
      bc+=1
    end
    
    end
    
  end
  
  toChangeColumn=(0..9)
  toChangeColumn.each do |col|
    sheet1.row(1).set_format(col,format)
    sheet1.row(2).set_format(col,format)
  sheet1.row(0).set_format(col,format)
  #~ sheet2.row(0).set_format(col,format)
end
toChangeColumn=(0..2)
  toChangeColumn.each do |col|
    #~ sheet1.row(1).set_format(col,format)
    #~ sheet1.row(2).set_format(col,format)
  #~ sheet1.row(0).set_format(col,format)
  sheet2.row(0).set_format(col,format)
end
#sheet1.row(1).set_format(0..10,format_merged)

  
  
  toChangeColumn=[5]
    toChangeColumn.each do |col|
      for k in 3..sheet1.row_count
      #~ puts "Inside for loop for changing color: #{k}"
      if sheet1[k,5].to_s == "PASS"
        sheet1.row(k).set_format(col,pass)
        elsif sheet1[k,5].to_s=="FAIL"
          sheet1.row(k).set_format(col,fail)
          elsif sheet1[k,5].to_s=="Can Not Run"
            puts "Can Not Run..............."
          sheet1.row(k).set_format(col,cantrun)
          end
        k+=1
    end
    
  end    
  puts "Going to write the report#{docname}-#{release.serial}"
 
  begin
  book.write("D:\\rails\\testreport\\public\\AllReports\\#{docname}-#{release.serial}.xls")
  rescue Exception => e  
  puts "Some exception happened while writing the report+#{e}"
  
  end
  puts "After writing report"
    begin
    xl=WIN32OLE.new('Excel.Application')
    xl.DisplayAlerts=false
    #wb=xl.Workbooks.Open("D:\\rails\\testreport\\public\\AllReports\\RTA-Test-Report-#{release.serial}.xls")
    wb=xl.Workbooks.Open("D:\\rails\\testreport\\public\\AllReports\\#{docname}-#{release.serial}.xls")
    ws=wb.Worksheets(1)
    ws.range('a1:i2').Interior.ColorIndex=40
    ws.range('a3:i3').Interior.ColorIndex=36
    ws2=wb.Worksheets(2)
    ws2.range('a1:c1').Interior.ColorIndex=36
    #~ for i in 1..56
    #~ puts "For color #{i}"
    #~ ws.range("a#{i}:i#{i}").Interior.ColorIndex=i
  #~ end
  puts "Saving the report"
    wb.SaveAs("D:\\rails\\testreport\\public\\AllReports\\#{docname}-#{release.serial}.xls")
    ensure
    xl.quit
  end
  
  
  puts "Finished generating sheet 1 of the report"
  return "D:\\rails\\testreport\\public\\AllReports\\#{docname}-#{release.serial}.xls"
end
def return_testcaseNdesc(testcases,builds,tid,build_id)
  tc_details=Hash.new(0)
  testcases.each do |t|
    if t.id==tid
    tc_details["name"]=t.testcase_id
    tc_details["description"]=t.testdescription
    tc_details["profile"]=t.profile
  end
end

  builds.each do |b|
    if b.id==build_id
    tc_details["build"]=b.name  
  end
end  
  
  #~ tc_details["name"]=testcase.testcase_id
  #~ tc_details["description"]=testcase.testdescription
  #~ tc_details["profile"]=testcase.profile
  #~ tc_details["build"]=build.name
  return tc_details
end

end
