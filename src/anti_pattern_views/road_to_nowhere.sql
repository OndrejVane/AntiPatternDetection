/*
Anti-pattern name: Road To Nowhere

Description: The project is not sufficiently planned and therefore
             takes place on an ad hoc basis with an uncertain
             outcome and deadline. There is no project plan in the project.

Detection: There is no activity in ALM that would indicate the creation
           of a project plan. There will be no document in the wiki
           called the "Project Plan". Project plan should be created in first or
           second iteration. Also could be detected with field change view. If is
           a lot of changes on issues in the beginning of the iteration so then could
           indicate some planning.

           TODO: 1) detekovat, že na začátku iterací probíhá plánování
                    => pomocí fieldChangeView
                    => zde není uvedeno, kdy se změnilo pole asignee (je zde pouze logtime a přidání/úprava komentáře)
                    => teoreticky by se většina aktivit měla vytvářet na začátku iterace(mohou být už vytvořeny během iterace) a následně by se dalo detekovat, jestli
                    proběhlo na začátku iterace nějaké plánování

*/
select * from workunitview inner join fieldchangeview on workunitview.id = fieldchangeview.itemId where `projectId` = 5 order by `startDate`

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

select @projectId, @numberOfIssuesForProjectPlan, @numberOfWikipagesForProjectPlan, if(@numberOfWikipagesForProjectPlan = 0 AND @numberOfIssuesForProjectPlan = 0, 1, 0) as `Anti-pattern occurrence`;

