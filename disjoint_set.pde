




class DisjointSet {
  int[] parent, rank, size;
  DisjointSet(int s) { //unlinked disjoint set of size s
    parent=new int[s]; rank=new int[s]; size=new int[s];
    for(int i=0; i<s; i++) { parent[i]=i; rank[i]=1; size[i]=1; }
  }
  
  int find(int a) {
    int p=parent[a];
    while(p!=parent[p]) { p=parent[p]; }
    parent[a]=p; //reduce tree height
    return(p);
  }
  
  void merge(int a, int b) {
    int ra=find(a), rb=find(b);
    if(ra!=rb) {
      int ranka=rank[ra], rankb=rank[rb];
      if(ranka<rankb) {
        parent[ra]=rb;
        size[rb]+=size[ra];
      }
      else if(rankb<ranka) {
        parent[rb]=ra;
        size[ra]+=size[rb];
      }
      else {
        parent[ra]=rb;
        rank[rb]++;
        size[rb]+=size[ra];
      }
    }
  }
}
