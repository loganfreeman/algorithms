def subsets(arr)
  return [[]] if arr.empty?
  old_subsets = subsets(arr.drop(1))
  new_subsets = []
  old_subsets.each do |subset|
    new_subsets << subset + [arr.first]
  end
  old_subsets + new_subsets
end
