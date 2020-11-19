/* Show all projects and detect anti-patterns */

select
    project.id as `ID` ,
    project.name as `Project Name`,
    too_long_sprint_view.`Anti-pattern occurrence` as `Too Long Sprint`,
    varying_sprint_length_view.`Anti-pattern occurrence` as `Varying Sprint Length`
from
    project
    inner join too_long_sprint_view on project.id = too_long_sprint_view.ID
    inner join varying_sprint_length_view on project.id = varying_sprint_length_view.ID;
