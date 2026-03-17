create or replace function get_driver_profile_by_id(
  driver_id uuid
)
returns table (
  id uuid,
  car_make text,
  car_model text,
  car_year text,
  car_plate text,
  car_color text,
  mx_id text,
  is_sharing boolean,
  lat float,
  long float,
  average_rating numeric,
  review_count bigint
)
language plpgsql
as $$
begin
  -- Return a single driver's profile, calculating the rating metrics
  return query
  select
    d.id,
    d.car_make,
    d.car_model,
    d.car_year,
    d.car_plate,
    d.car_color,
    d.mx_id,
    d.is_sharing,
    st_y(d.location::extensions.geometry) as lat,
    st_x(d.location::extensions.geometry) as long,
    COALESCE(AVG(r.rating), 0.0) AS average_rating, -- Calculate the average rating
    COUNT(r.rating) AS review_count               -- Count the total reviews
  from drivers d
  LEFT JOIN ratings r ON d.id = r.target_driver_id
  where d.id = driver_id -- Filter by the input ID
  GROUP BY
    d.id,
    d.car_make,
    d.car_model,
    d.car_year,
    d.car_plate,
    d.car_color,
    d.mx_id,
    d.is_sharing,
    d.location;

end;
$$;