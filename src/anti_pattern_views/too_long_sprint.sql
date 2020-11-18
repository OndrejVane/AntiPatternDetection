/*
Anti-pattern name: Too Long Sprint

Description: Iterations too long. (ideal iteration length is about 1-2 weeks,
             maximum 3 weeks). It could also be detected here if the length
             of the iteration does not change often (It can change at the
             beginning and at the end of the project, but it should not
             change in the already started project).

Detection: Detect the beginning and end of the iteration and what is
           the interval between these time points. We should exclude
           the initial and final iterations, as they could skew the result.
*/

create or replace view too_long_sprint_view as
    select project.id as `ID`,
           project.name as `Project Name`,
           project.description as `Description`,
           count(*) as `Number of iterations`,
           avg(datediff(iteration.endDate, iteration.startDate)) as `Average Iteration Length`,
           max(datediff(iteration.endDate, iteration.startDate)) as `Max Iteration Length`,
           min(datediff(iteration.endDate, iteration.startDate)) as `Min Iteration Length`,
           (select avg(datediff(iteration.endDate, iteration.startDate))
                from iteration
                where   project.id = iteration.superProjectId
                        and
                        iteration.id != (select id from iteration where superProjectId = project.id order by startDate limit 1 )
                        and
                        iteration.id != (select id from iteration where superProjectId = project.id order by startDate desc limit 1 )
                        ) as  `Average Iteration Length Without Extremes`,
           (select max(datediff(iteration.endDate, iteration.startDate))
                from iteration
                where   project.id = iteration.superProjectId
                        and
                        iteration.id != (SELECT id from iteration where superProjectId = project.id order by startDate limit 1 )
                        and
                        iteration.id != (select id from iteration where superProjectId = project.id order by startDate desc limit 1 )
                        ) as  `Max Iteration Length Without Extremes`,
           (select  min(datediff(iteration.endDate, iteration.startDate))
                from iteration
                where   project.id = iteration.superProjectId
                        and
                        iteration.id != (SELECT id from iteration where superProjectId = project.id order by startDate limit 1 )
                        and
                        iteration.id != (select id from iteration where superProjectId = project.id order by startDate desc limit 1 )
                        ) as  `Min Iteration Length Without Extremes`,
           if(
                (select avg(datediff(iteration.endDate, iteration.startDate))
                 from iteration
                 where  project.id = iteration.superProjectId
                        and
                        iteration.id != (select id from iteration where superProjectId = project.id order by startDate limit 1 )
                        and
                        iteration.id != (select id from iteration where superProjectId = project.id order by startDate desc limit 1 )
                 ) > (select value from anti_pattern_properties where key = 'max_sprint_length'), true, false) as `Anti-pattern occurrence`
    from project inner join iteration on project.id = iteration.superProjectId
    group by project.id
    order by project.id;

select * from too_long_sprint_view;
