function bool = is_leaf(node)
if isempty(node.left)
    if isempty(node.right)
        bool = true;
    else
        bool = false;
    end
elseif size(node.data,1) == 1
    bool = true;
else
    bool = false;
end
end