### [蓝色空间](http://mechempire.cn/meches/554b67d76d656364ee0c0000) 代码

> 方神说：你们随便看，没事！另外不要在意奇怪的变量名

    RobotAI_Order go(double x,double y,const RobotAI_BattlefieldInformation& info, int myID) {
      RobotAI_Order order;
      auto me = info.robotInformation[myID];
      double dx = x - me.circle.x;
      double dy = y - me.circle.y;
      double theta = atan2(dy, dx)*180.0 / PI;
      double mt =me.engineRotation;
      double dt = theta - mt;
      AngleAdjust(dt);
      const double eps = 1e-3;

      if (dt > eps){
        order.eturn = 1;
      } else if (dt < -eps){
        order.eturn = -1;
      } else {
        order.eturn = 0;
        
      }
      order.run = 1;
      return order;
    }

    double dis(double x1, double y1, double x2, double y2) {
      return sqrt((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1));
    }

    double dis(const Circle& a, const Circle& b){
      return dis(a.x, a.y, b.x, b.y);
    }
    void RobotAI::Update(RobotAI_Order& order,const RobotAI_BattlefieldInformation& info,int myID)
    {
      auto& me = info.robotInformation[myID];
      auto& arsenal = info.arsenal;
      double dis0 = dis(me.circle.x, me.circle.y, arsenal[0].circle.x, arsenal[0].circle.y);
      double dis1 = dis(me.circle.x, me.circle.y, arsenal[1].circle.x, arsenal[1].circle.y);
      auto& target = info.robotInformation[1 - myID];
      int p, q;

      if (dis0 < dis1)
        p = 0, q = 1;
      else
        p = 1, q = 0;

      if (info.arsenal[p].respawning_time ==0 ){
        order = go(info.arsenal[p].circle.x, info.arsenal[p].circle.y, info, myID);
      }
      else if (info.arsenal[q].respawning_time == 0){
        order = go(info.arsenal[q].circle.x, info.arsenal[q].circle.y, info, myID);
      }else{
        order.run = 1;
        order.eturn = 1;

      }

      for (int i = 0; i < info.num_bullet; i++){
        const auto& bullet = info.bulletInformation[i];
        if (bullet.launcherID != myID){
          if (dis(me.circle.x, me.circle.y,bullet.circle.x,bullet.circle.y) < 50){
            order.run = 0;
            
          }
          
        }
      }


      static double mlx = me.circle.x, mly = me.circle.y;
      if (mlx == me.circle.x && mly == me.circle.y){
        order.run = -1;
        order.eturn = 1;
      }

      mlx = me.circle.x;
      mly = me.circle.y;

      double emdis = dis(me.circle.x, me.circle.y, target.circle.x, target.circle.y);
      static double elx = target.circle.x, ely = target.circle.y;
      double eex = emdis/15.0 * (target.circle.x - elx) + target.circle.x;
      double eey = emdis/15.0 * (target.circle.y - ely) + target.circle.y;

      elx = target.circle.x;
      ely = target.circle.y;

      double the = atan2(eey - me.circle.y, eex - me.circle.x)*180.0 / PI;
      double wp = me.weaponRotation;

      double di = the - wp;
      AngleAdjust(di);
      
      if (di>3.00){
        order.wturn = 1;
      }
      else if (di<-3.0) {
        order.wturn = -1;
      }
      double miss = dis(me.circle.x, me.circle.y, eex, eey)*tan(di * PI / 180.0 / 2);
      if (miss < 10){
        order.fire = 1;
        bool blocked = false;
        const int TN = 10;
        for (int i = 0; i < TN; i++){
          double tx = me.circle.x + (eex - me.circle.x)*i / TN;
          double ty = me.circle.y + (eey - me.circle.y)*i / TN;
          for (int j = 0; j < info.num_obstacle; ++j){
            double ddd = dis(tx, ty, info.obstacle[j].x, info.obstacle[j].y);
            if (ddd< info.obstacle[j].r+3)
              blocked = true;
          }
          if (blocked)
            break;
        }
        if (blocked){
          order.fire = 0;
        }

      }
      else{
        order.fire = 0;
      }
    }