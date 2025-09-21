import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  @State points: number = 100
  @State mustWin: boolean = false
  @State currentIndex: number = -1
  @State isDrawing: boolean = false
  @State prizeMessages: string[] = []

  private rewards: Resource[] = [
    $r('app.media.prize1'),
    $r('app.media.prize2'),
    $r('app.media.prize3'),
    $r('app.media.prize4'),
    $r('app.media.prize5'),
    $r('app.media.prize6'),
    $r('app.media.prize7'),
    $r('app.media.prize8'),
  ]

  private readonly ringCount: number = 8
  private readonly center: number = 140
  private readonly radius: number = 100
  private readonly itemSize: number = 60
  private readonly btnSize: number = 100

  private angleAt(i: number): number {
    return 2 * Math.PI * i / this.ringCount;
  }
  private posX(i: number): number {
    return this.center + this.radius * Math.cos(this.angleAt(i)) - this.itemSize / 2;
  }
  private posY(i: number): number {
    return this.center + this.radius * Math.sin(this.angleAt(i)) - this.itemSize / 2;
  }

  private startDraw(): void {
    if (this.isDrawing) return;
    if (this.points < 10) {
      promptAction.showToast({ message: '积分不足！' });
      return;
    }
    this.points -= 10;
    this.isDrawing = true;

    const target: number = this.mustWin ? 7 : Math.floor(Math.random() * this.ringCount);
    const totalSpins: number = this.ringCount * 3 + target;
    let step: number = 0;

    const spin = (delay: number): void => {
      this.currentIndex = step % this.ringCount;
      step++;
      if (step > totalSpins) {
        this.isDrawing = false;
        this.prizeMessages.unshift(`⚡ 第 ${this.prizeMessages.length + 1} 次：获得第 ${target + 1} 个奖品！`);
        return;
      }
      const remain: number = totalSpins - step;
      const nextDelay: number =
        remain < 10 ? delay + 35 :
          remain < 20 ? delay + 15 : delay;
      setTimeout(() => spin(nextDelay), nextDelay);
    };

    spin(80);
  }

  build() {
    Column({ space: 16 }) {
      // 标题
      Text('⚡ CYBER 抽奖机 ⚡')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#00F5FF')
        .shadow({ radius: 8, color: '#FF00FF', offsetX: 2, offsetY: 2 })
        .margin({ top: 20 })

      // 积分显示
      Row() {
        Text('积分:')
          .fontSize(20).fontColor('#FF00FF').fontWeight(FontWeight.Bold)
        Text(`${this.points}`)
          .fontSize(22).fontWeight(FontWeight.Bold).fontColor('#00F5FF')
      }
      .padding({ top: 8, bottom: 8, left: 16, right: 16 })
      .backgroundColor('#1A1A2E')
      .borderRadius(8)
      .shadow({ radius: 6, color: '#FF00FF' })

      // 外圈 + 中心按钮
      Stack() {
        ForEach(this.rewards, (img: Resource, i: number) => {
          Image(img)
            .width(this.itemSize).height(this.itemSize)
            .borderRadius(10)
            .backgroundColor('#111827')
            .border({
              width: 3,
              color: this.currentIndex === i ? '#FF00FF' : '#00F5FF'
            })
            .shadow({
              radius: this.currentIndex === i ? 10 : 5,
              color: this.currentIndex === i ? '#FF00FF' : '#00F5FF'
            })
            .position({ x: this.posX(i), y: this.posY(i) })
        })

        // 中间发光按钮
        Button(this.isDrawing ? 'RUN...' : '抽奖')
          .width(this.btnSize).height(this.btnSize)
          .borderRadius(this.btnSize / 2)
          .backgroundColor('#0F172A')
          .fontColor('#00F5FF')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .shadow({ radius: 12, color: '#FF00FF', offsetX: 0, offsetY: 0 })
          .enabled(!this.isDrawing)
          .onClick(() => this.startDraw())
          .position({
            x: this.center - this.btnSize / 2,
            y: this.center - this.btnSize / 2
          })
      }
      .width(this.center * 2).height(this.center * 2)

      // 必中大奖开关
      Row() {
        Text('必中大奖 🔮')
          .fontSize(18)
          .fontColor('#FF00FF')
          .margin({ right: 8 })
        Toggle({ type: ToggleType.Switch, isOn: this.mustWin })
          .onChange((v: boolean) => (this.mustWin = v))
      }
      .padding({ left: 12, right: 12 })
      .backgroundColor('#1F2937')
      .borderRadius(10)
      .shadow({ radius: 6, color: '#00F5FF' })

      // 中奖记录
      if (this.prizeMessages.length > 0) {
        Column({ space: 8 }) {
          Text("🎇 中奖记录")
            .fontSize(18).fontColor('#00F5FF').fontWeight(FontWeight.Bold)
            .shadow({ radius: 6, color: '#FF00FF' })
            .margin({ bottom: 6 })

          ForEach(this.prizeMessages, (msg: string, idx: number) => {
            Text(msg)
              .fontSize(15)
              .fontColor('#00F5FF')
              .backgroundColor('#111827')
              .borderRadius(6)
              .padding(6)
              .shadow({ radius: 4, color: '#FF00FF' })
          })
        }
        .width('92%')
        .padding(12)
        .backgroundColor('#0F172A')
        .borderRadius(12)
        .shadow({ radius: 10, color: '#00F5FF' })
      }

      Blank().layoutWeight(1)
    }
    .width('100%').height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#0D0D0D')
  }
}
