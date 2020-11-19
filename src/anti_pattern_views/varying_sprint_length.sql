/*
Anti-pattern name: Varying Sprint Length

Description: The length of the sprint changes very often.
             It is clear that iterations will be different
             lengths at the beginning and end of the project,
             but the length of the sprint should not change
             during the project.


Detection: Detect sprint lengths throughout the project
           and see if they are too different. Possibility to
           eliminate the first and last sprint. It could be
           otherwise long. Detection would be similar to
           Too Long sprint anti-pattern.
*/

create or replace view varying_sprint_length_view as
    select project.id as `ID`,
           project.name as `Project Name`,
           project.description as `Description`,
           count(*) as `Number Of Iterations Without Extremes`,
           std(datediff(iteration.endDate, iteration.startDate)) as `Standard Deviation Of Iteration Length - σ`,
           std(datediff(iteration.endDate, iteration.startDate)) * std(datediff(iteration.endDate, iteration.startDate)) as `Deviation Of Iteration Length - σ^2`,
           if(
                std(datediff(iteration.endDate, iteration.startDate))
                >
                (SELECT value FROM anti_pattern_properties a where a.key = 'max_standard_deviation_for_iteration_length'), true, false) as `Anti-pattern occurrence`
    from project inner join iteration on project.id = iteration.superProjectId
    where project.id = iteration.superProjectId
          and
            iteration.id != (select id from iteration where superProjectId = project.id order by startDate limit 1 )
          and
            iteration.id != (select id from iteration where superProjectId = project.id order by startDate desc limit 1 )
    group by project.id
    order by project.id;

select * from varying_sprint_length_view;

