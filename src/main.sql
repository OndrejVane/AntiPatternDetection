/* Show all projects and detect anti-patterns */

select
    project.id as `ID` ,
    project.name as `Project Name`,
    too_long_sprint_view.`Anti-pattern occurrence` as `Too Long Sprint`
from project inner join too_long_sprint_view on project.id = too_long_sprint_view.ID;
