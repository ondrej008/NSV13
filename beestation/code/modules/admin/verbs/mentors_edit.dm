/******************************************
It's like permissions panel, but for mentors,
also probably less secure, but honestly dude 
its mentors, not actual dangerous perms
******************************************/
/client/proc/edit_mentors()
    set category = "Admin"
    set name = "Mentor Panel"
    set desc = "Edit mentors"
    
    if(!check_rights(R_PERMISSIONS))
        return
    if(!SSdbcore.IsConnected())
        to_chat(src, "<span class='danger'>Failed to establish database connection.</span>")
        return
    
    var/html = "<h1>Mentor Panel</h1>\n"
    html += "<A HREF='?mentor_edit=add'>Add a Mentor</A>\n"
    html += "<table style='width: 100%' border=1>\n"
    html += "<tr><th>Mentor Ckey</th><th>Remove</th></tr>\n"

    var/datum/DBQuery/query_mentor_list = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("mentor")]")
    query_mentor_list.Execute()
    while(query_mentor_list.NextRow())
        html += "<tr><td>[query_mentor_list.item[1]]</td><td><A HREF='?mentor_edit=remove;mentor_ckey=[query_mentor_list.item[1]]'>X</A></td></tr>\n"

    html += "</table>"

    usr << browse("<!DOCTYPE html><html>[html]</html>","window=editmentors;size=1000x650")

/client/Topic(href, href_list)
    ..()
    if(href_list["mentor_edit"])
        if(!check_rights(R_PERMISSIONS))
            message_admins("[key_name_admin(usr)] attempted to edit mentor permissions without sufficient rights.")
            log_admin("[key_name(usr)] attempted to edit mentor permissions without sufficient rights.")
            return
        if(IsAdminAdvancedProcCall())
            to_chat(usr, "<span class='admin prefix'>Mentor Edit blocked: Advanced ProcCall detected.</span>")
            return

        if(href_list["add"])
            var/newguy = input("Enter the key of the mentor you wish to add.", "")
            var/datum/DBQuery/query_add_mentor = SSdbcore.NewQuery("INSERT INTO [format_table_name("mentor")] (ckey) VALUES (newguy)")
            query_add_mentor.Execute()
            message_admins("[key_name(usr)] made [newguy] a mentor.")
            log_admin("[key_name(usr)] made [newguy] a mentor.")
            return

        if(href_list["remove"])
            var/datum/DBQuery/query_remove_mentor = SSdbcore.NewQuery("DELETE FROM [format_table_name("mentor")] WHERE ckey=`[href_list["mentor_ckey"]]`")
            query_remove_mentor.Execute()
            message_admins("[key_name(usr)] de-mentored [href_list["mentor_ckey"]]")
            log_admin("[key_name(usr)] de-mentored [href_list["mentor_ckey"]]")
            return


