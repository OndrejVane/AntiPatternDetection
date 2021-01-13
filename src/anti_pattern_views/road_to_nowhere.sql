/*
Anti-pattern name: Road To Nowhere

Description: The project is not sufficiently planned and therefore
             takes place on an ad hoc basis with an uncertain
             outcome and deadline. There is no project plan in the project.

Detection: There is no activity in ALM that would indicate the creation
           of a project plan. There will be no document in the wiki
           called the "Project Plan". Project plan should be created in first or
           second iteration.

           TODO: 1) detekovat, že na začátku iterací probíhá plánování

*/

create or replace view road_to_nowhere_view as
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

select * from fieldchangeview;

/* NOVÁ VERZE */
set @projectId = 5;
set @firstIterationStartDate = (select startDate from iteration where superProjectId = @projectId ORDER BY startDate LIMIT 1 offset 0);
set @secondIterationStartDate = (select startDate from iteration where superProjectId = @projectId ORDER BY startDate LIMIT 1 offset 1);
set @numberOfIssuesForProjectPlan = (SELECT count(*) from workunitview where projectId = @projectId  and (
    				workunitview.name like '%plán%projektu%' or
                    workunitview.name like '%project%plan%' or
                    workunitview.name like '%plan%project%' or
                    workunitview.name like '%proje%plán%')
					AND
					(iterationStartDate = @firstIterationStartDate OR
                        iterationStartDate = @secondIterationStartDate));
set @numberOfWikipagesForProjectPlan = (SELECT count(*) from artifactview where projectId = @projectId AND artifactClass like 'WIKIPAGE' AND (
    				artifactview.name like '%plán%projektu%' or
                    artifactview.name like '%project%plan%' or
                    artifactview.name like '%plan%project%' or
                    artifactview.name like '%proje%plán%'));

select @projectId, @numberOfIssuesForProjectPlan, @numberOfWikipagesForProjectPlan;

