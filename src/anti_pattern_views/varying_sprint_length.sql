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

/* Set database */
use ppicha;
/* Init project id */
set @projectId = 5;
/* Maximum sprint length variance */
set @maxSprintVariance = 1;
/* Exclude first and last iteration? */
set @excludeFirstAndLastIteration = true;
/* Id of first iteration */
set @idOfFirstIteration = (select id from iteration where iteration.superProjectId = @projectId order by startDate limit 1);
/* Id of last iteration */
set @idOfLastIteration = (select id from iteration where iteration.superProjectId = @projectId order by startDate desc limit 1);
/* Select all iterations with their length */
select datediff(endDate, startDate)
    from iteration
    where iteration.superProjectId = @projectId
            and
          iteration.id != if(@excludeFirstAndLastIteration = true, @idOfFirstIteration, -1)
            and
          iteration.id != if(@excludeFirstAndLastIteration = true, @idOfLastIteration, -1)
    order by iteration.startDate;

