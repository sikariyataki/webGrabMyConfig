-- makes a deep copy of a given table (the 2nd param is optional and for internal use)
-- circular dependencies are correctly copied.
function table.copy(t, lookup_table)
 local copy = {}
 for i,v in t do
  if type(v) ~= "table" then
   copy[i] = v
  else
   lookup_table = lookup_table or {}
   lookup_table[t] = copy
   if lookup_table[v] then
    copy[i] = lookup_table[v] -- we already copied this table. reuse the copy.
   else
    copy[i] = table.copy(v,lookup_table) -- not yet copied. copy it.
   end
  end
 end
 return copy
end