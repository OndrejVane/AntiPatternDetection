/*
Anti-pattern name: Business as usual (No sprint retrospective)

Description: Absence of a retrospective after individual
             iterations or after the completion project

Detection: There will be no activities in the project
           that would indicate that a retrospective is
           taking place (issue with the name of the
           retrospective, issue on which all team members
           log, issue that is repeated periodically,
           issue to which no commit is bound, issue which
           will be marked as administration or something like that).
           There will be no notes in the wiki or other tool called
           retrospectives (% retr%).

TODO: 1) zjistit, jestli je to issue bez commitu => kde zjistit návaznost commitů na aktivitu
      2) zjistit, že na něm logují všichni členové týmu => kde zjistit kdo má zalogováno na aktivitě
      3) zjistit nějakou zmíňku v ve wiki => zepatat se, kde se nacházejí poznámky z wiki
*/
create or replace view business_as_usual_view as
    select project.id as `ID`,
           project.name as `Project Name`,
           project.description as `Description`,
           count(*) as `Activity name or description with substring "retro"`
    from project inner join workunitview on project.id = workunitview.projectId
    where workunitview.name LIKE '%retr%'
            or
          workunitview.description like '%retr%'
    group by project.id
    order by project.id;

select * from business_as_usual_view;
