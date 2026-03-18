create or replace function get_nearby_drivers(
  my_lat float,
  my_long float,
  radius_meters int
)
returns table (
  id uuid,
  car_make text,
  car_model text,
  car_year text,
  car_plate text,
  car_color text,
  mx_id text,
  lat float,
  long float,
  dist_meters float,
  average_rating numeric,
  review_count bigint
)
language plpgsql
as $$
declare
  requesting_user_sharing boolean;
begin
  -- 1. Check if the requesting user is sharing their location
  select is_sharing into requesting_user_sharing
  from drivers
  where drivers.id = auth.uid();

  -- 2. If they are NOT sharing (or don't exist), return nothing
  if requesting_user_sharing is not true then
    return;
  end if;

  -- 3. Return nearby drivers, joining with ratings table to calculate average and count
  return query
  select
    d.id,
    d.car_make,
    d.car_model,
    d.car_year,
    d.car_plate,
    d.car_color,
    d.mx_id,
    st_y(d.location::extensions.geometry) as lat,
    st_x(d.location::extensions.geometry) as long,
    st_distance(d.location, st_point(my_long, my_lat)::geography) as dist_meters,
    COALESCE(AVG(r.rating), 0.0) AS average_rating,
    COUNT(r.rating) AS review_count
  from drivers d
  LEFT JOIN ratings r ON d.id = r.target_driver_id
  where d.is_sharing = true
  and d.id != auth.uid()
  and st_dwithin(d.location, st_point(my_long, my_lat)::geography, radius_meters)
  GROUP BY
    d.id,
    d.car_make,
    d.car_model,
    d.car_year,
    d.car_plate,
    d.car_color,
    d.mx_id,
    d.location
  ORDER BY
    dist_meters ASC;
end;
$$;