/*
Anti-pattern name: Indifferent specialist

Description: A team member who is a specialist in just one thing and does not want to learn new things.
             He refuses to learn new things outside of his specialization. It often disparages other
             "technologies". They reduce the seriousness of things that do not specialize in his specialization.

Detection: Take a look at the different types of activities (testing, implementation,
           documentation, meetings, etc.) and find out the share among individual team members.
           One member should not do only one thing.
*/

/* Set project id */
set @projectId = 5;
/* Classify over category name  for each project member */
    select `assigneeId` as `Project member id`,
           `assigneeName` as `Project member name`,
            count(*) as `Number of issues`,
            count(case when categoryName like '%test%' then 1 end) as `Number of testing issues`,
            count(case when categoryName like '%arch%' or categoryName like '%des%' then 1 end) as `Number of architecture issues`,
            count(case when categoryName like '%dev%' or categoryName like '%impl%' or categoryName like '%výv%' then 1 end) as `Number of developing issues`,
            count(case when categoryName like '%admin%' or categoryName like '%schůz%' or categoryName like '%proc%' or categoryName like '%meet%' then 1 end) as `Number of administrative issues`,
            count(case when categoryName like '%req%' or categoryName like '%pož%' then 1 end) as `Number of requirements issues`,
            count(distinct `categoryName`) as `Uniq number of categories`
    from workunitview as wuv
    where wuv.`projectId` = @projectId and
          wuv.`assigneeName` != 'unknown' group by wuv.`assigneeId`;

/* Classify over activity name */
    select `assigneeId` as `Project member id`,
           `assigneeName` as `Project member name`,
            count(*) as `Number of issues`,
            count(case when name like '%test%' then 1 end) as `Number of testing issues`,
            count(case when name like '%arch%' or name like '%des%' then 1 end) as `Number of architecture issues`,
            count(case when name like '%dev%' or name like '%impl%' or name like '%výv%' then 1 end) as `Number of developing issues`,
            count(case when name like '%admin%' or name like '%schůz%' or name like '%proc%' or name like '%meet%' then 1 end) as `Number of administrative issues`,
            count(case when name like '%req%' or name like '%pož%' then 1 end) as `Number of requirements issues`,
            count(distinct name) as `Uniq number of categories`
    from workunitview as wuv
    where wuv.`projectId` = @projectId and
          wuv.`assigneeName` != 'unknown' group by wuv.`assigneeId`;
