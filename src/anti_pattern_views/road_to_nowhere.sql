/*
Anti-pattern name: Road To Nowhere

Description: The project is not sufficiently planned and therefore
             takes place on an ad hoc basis with an uncertain
             outcome and deadline. There is no project plan in the project.

Detection: There is no activity in ALM that would indicate the creation
           of a project plan. There will be no document in the wiki
           called the "Project Plan".

           TODO: hledat projektový plán v dms nebo ve wiki => zeptat se, kde jsou uloženy dokumenty z wiki nebo DMS
*/

create or replace view road_to_nowhere as
    select project.id as `ID`,
           project.name as `Project Name`,
           count(*) as `Count of issues`,
           (select count(*)
            from workunitview
            where project.id = workunitview.projectID
                and
                (   workunitview.name like '%plán%projektu%' or
                    workunitview.name like '%project%plan%' or
                    workunitview.name like '%plan%project%'or
                    workunitview.name like '%proje%plán%')) as `Project plan activities`,
            IF((select count(*)
            from workunitview
            where project.id = workunitview.projectID
                and
                (   workunitview.name like '%plán%projektu%' or
                    workunitview.name like '%project%plan%' or
                    workunitview.name like '%plan%project%'or
                    workunitview.name like '%proje%plán%')) >= 1, false, true) as `Anti-pattern occurrence`
    from project inner join workunitview on project.id = workunitview.projectId
    group by project.id
    order by project.id;

select * from road_to_nowhere;
