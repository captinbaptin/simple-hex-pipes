




int[] randomOrder(int s) {
  int[] out=new int[s];
  for(int i=0; i<s; i++) { out[i]=i; }
  for(int i=s-1; i>0; i--) {
    int buff=out[i]; int rind=int(random(i+1)); out[i]=out[rind]; out[rind]=buff;
  }
  return(out);
}




String millisToString(int mil) {
  String out=""+mil%1000;
  mil/=1000;
  if(mil==0) { return(out); }
  out=(mil%60)+"."+out;
  if(mil%60<10) { out="0"+out; }
  mil/=60;
  if(mil==0) { return(out); }
  out=(mil%60)+":"+out;
  if(mil%60<10) { out="0"+out; }
  mil/=60;
  if(mil==0) { return(out); }
  out=(mil)+":"+out;
  return(out);
}
