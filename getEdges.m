function [Edge_Node, Edges, Edge_Element] = getEdges(elements)

% 1. A matrix Edge_Node which is of size 2xnrofedges: (nodnr1; nodnr2, edge)
%    containing the numbers of the two nodes that define each edge
eleIndex = [1:length(elements)]';
edges2element = [sort([elements(:, 1:2); elements(:, 2:3); elements(:, 3),...
    elements(:, 1)], 2), [eleIndex; eleIndex; eleIndex]];
edgesUnique = unique(edges2element(:,1:2), 'rows');
nEdg = length(edgesUnique);
Edge_Node = [edgesUnique, [1: nEdg]'];

% 2. A matrix Edges size 3xnrofelements which gives (edgenr1; edgenr2; egenr3, element)
%    so you would have access to the three edges each element have.
nEle = length(elements);
Edges = zeros(nEle, 4);
for i = 1: nEle
    for n = 1:3
        oneEdge = edges2element(i+(n-1)*nEle, 1:2);
        % find the edge id from the Edge_Node array
        eId = find((Edge_Node(:,1) == oneEdge(1)) & (Edge_Node(:,2) == oneEdge(2)));
        Edges(i, n) = Edge_Node(eId, 3);
    end
    Edges(i, 4) = edges2element(i, 3);
end

% 3. A matrix Edge_Element of size 2xnrofedges: (el1; el2, edge)
%    so for each edge you would know the two elements that share that edge.
Edge_Element = zeros(nEdg, 3);
for i = 1: nEdg
    eleId = find(Edges(:,1:3)==i);
    Edge_Element(i, 1:2) = Edges(mod(eleId-1, nEle)+1, 4)';
    Edge_Element(i, 3) = i;
end

boundaryId = (Edge_Element(:,1) == Edge_Element(:, 2));
Boundary = Edge_Element(boundaryId, 3);
Edge_Element = Edge_Element(~boundaryId, :);
