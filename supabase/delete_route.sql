CREATE OR REPLACE FUNCTION delete_route(p_route_id bigint)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Use the parameter name with a prefix to avoid ambiguity
  DELETE FROM public.route_route_experience 
  WHERE route_id = p_route_id;
  
  DELETE FROM public.route 
  WHERE id = p_route_id;
END;
$$;