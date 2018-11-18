//class Cluster {
//    ArrayList<Particle> nodes;
//    float diameter;
    
//    Cluster(int n, float d, Vec2D center) {
//      nodes = new ArrayList<Particle>();
//      diameter = d;
      
//      for (int i = 0; i < n; i++) {
//        Particle p = new Particle(center.add(Vec2D.randomVector()));
//        p.display();
//        nodes.add(p);
//      }
//    }
    
//    void display(){
//      for (int i = 0; i < nodes.size(); i++) {
//        VerletParticle2D ni = nodes.get(i);
//        for (int j = i+1; j < nodes.size(); j++) { 
//          VerletParticle2D nj = nodes.get(j);
//          physics.addSpring(new VerletSpring2D(ni,nj,diameter,0.01));
//        }
//      } 
//    }
//}
