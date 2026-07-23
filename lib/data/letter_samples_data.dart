import '../models/letter_category.dart';
import '../models/letter_sample.dart';
import '../models/writing_style.dart';

/// Static sample library bundled with the app. In this MVP there is no
/// backend — every sample below is fixed content used for browsing and as
/// reference material when composing a new letter.
const List<LetterSample> letterSamples = [
  // --- お礼 -----------------------------------------------------------
  LetterSample(
    id: 'gratitude_boss',
    category: LetterCategory.gratitude,
    title: '上司へのお礼',
    description: 'お世話になった上司への感謝を伝える手紙です。',
    style: WritingStyle.polite,
    body: '''○○部長

このたびは、大変お世話になり、心より感謝申し上げます。

部長には、入社以来、仕事の進め方や考え方など、さまざまなことをご指導いただきました。おかげさまで、多くのことを学び、成長することができました。

いつも温かく見守っていただき、本当にありがとうございました。

今後もご指導いただいたことを活かし、精一杯努めてまいります。
今後ともどうぞよろしくお願い申し上げます。''',
  ),
  LetterSample(
    id: 'gratitude_retirement',
    category: LetterCategory.gratitude,
    title: '退職のお礼',
    description: '長年お世話になった職場への感謝を伝える手紙です。',
    style: WritingStyle.polite,
    body: '''○○部長

拝啓　時下ますますご清祥のこととお慶び申し上げます。

このたび、○月○日をもちまして退職することとなりました。

入社以来、約三年間にわたり、温かくご指導いただき、心より感謝申し上げます。部長の的確なご指導とお人柄に支えられ、多くのことを学び、成長することができました。

至らぬ点も多くあったかと存じますが、いつも信じて任せてくださったこと、本当にありがとうございました。

今後もご指導いただいたことを胸に、新たな道でも精一杯努めてまいります。

末筆ではございますが、部長のますますのご健勝とご活躍をお祈り申し上げます。

敬具''',
  ),
  LetterSample(
    id: 'gratitude_colleague',
    category: LetterCategory.gratitude,
    title: '同僚へのお礼',
    description: '一緒に働いた同僚への感謝を伝える手紙です。',
    style: WritingStyle.soft,
    body: '''○○さん

いつも本当にありがとうございます。

忙しいときに助けてもらったこと、何気ない会話に励まされたこと、ひとつひとつがとても心強かったです。

○○さんと一緒に仕事ができて、心からよかったと思っています。

これからもどうぞよろしくお願いします。''',
  ),
  LetterSample(
    id: 'gratitude_teacher',
    category: LetterCategory.gratitude,
    title: '先生へのお礼',
    description: '学校の先生や指導者への感謝を伝える手紙です。',
    style: WritingStyle.veryPolite,
    body: '''○○先生

拝啓　先生には日頃より温かいご指導を賜り、心より御礼申し上げます。

至らない私を根気強く導いてくださり、多くのことを学ばせていただきました。先生の励ましのお言葉に、何度も救われました。

いただいたご恩は、これからの歩みの中で少しずつお返しできるよう努めてまいります。

末筆ながら、先生の変わらぬご健勝をお祈り申し上げます。

敬具''',
  ),
  LetterSample(
    id: 'gratitude_client',
    category: LetterCategory.gratitude,
    title: '取引先へのお礼',
    description: 'ビジネスシーンで使えるお礼の手紙です。',
    style: WritingStyle.veryPolite,
    body: '''○○株式会社
○○様

拝啓　貴社ますますご清栄のこととお慶び申し上げます。

このたびは格別のご高配を賜り、誠にありがとうございます。日頃より温かいご支援をいただき、社員一同心より感謝申し上げます。

今後とも変わらぬお付き合いのほど、何卒よろしくお願い申し上げます。

まずは書中にて御礼申し上げます。

敬具''',
  ),

  // --- お祝い ----------------------------------------------------------
  LetterSample(
    id: 'celebration_wedding_reply',
    category: LetterCategory.celebration,
    title: '結婚祝いのお礼',
    description: 'お祝いをいただいた方へのお礼の手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

このたびは、私たちの結婚に際し、心温まるお祝いをいただき、誠にありがとうございます。

いただいたお心遣いに、二人で何度も話しては嬉しく思っております。

未熟な二人ではございますが、これから力を合わせ、温かい家庭を築いてまいりたいと思います。

今後とも変わらぬお付き合いのほど、よろしくお願いいたします。''',
  ),
  LetterSample(
    id: 'celebration_birth',
    category: LetterCategory.celebration,
    title: '出産祝い',
    description: '新しい家族の誕生を祝う手紙です。',
    style: WritingStyle.soft,
    body: '''○○さん

ご出産、本当におめでとうございます。

新しい家族を迎えられたこと、心よりお祝い申し上げます。

慣れない日々できっと大変かと思いますが、どうかご無理なさらず、赤ちゃんとの時間を大切に過ごしてください。

ささやかですが、お祝いの気持ちをお贈りします。喜んでいただけたら嬉しいです。''',
  ),
  LetterSample(
    id: 'celebration_promotion',
    category: LetterCategory.celebration,
    title: '昇進のお祝い',
    description: '昇進・昇格を祝う手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

このたびのご昇進、心よりお祝い申し上げます。

日頃の真摯なお取り組みが実を結ばれたこと、私事のように嬉しく思っております。

これからも変わらぬご活躍を、陰ながら応援しております。

まずは書中にてお祝い申し上げます。''',
  ),

  // --- お詫び ----------------------------------------------------------
  LetterSample(
    id: 'apology_business_delay',
    category: LetterCategory.apology,
    title: '納期遅延のお詫び',
    description: '取引先への納期遅延をお詫びする手紙です。',
    style: WritingStyle.veryPolite,
    body: '''○○株式会社
○○様

拝啓　平素より格別のお引き立てを賜り、厚く御礼申し上げます。

このたびは、納期に遅れが生じましたこと、心よりお詫び申し上げます。ご迷惑をおかけしましたこと、深く反省しております。

今後は再発防止に努め、二度とこのようなことがないよう努めてまいります。

何卒ご寛容の程、お願い申し上げます。

敬具''',
  ),
  LetterSample(
    id: 'apology_personal',
    category: LetterCategory.apology,
    title: '友人への謝罪',
    description: '大切な友人へ素直な気持ちで謝る手紙です。',
    style: WritingStyle.soft,
    body: '''○○へ

先日は、私の言葉であなたを傷つけてしまい、本当にごめんなさい。

自分の気持ちばかりを優先してしまい、あなたの思いをきちんと聞けていませんでした。

これまで支えてもらってきたのに、悲しい思いをさせてしまったこと、心から反省しています。

またゆっくり話せる時間をもらえたら嬉しいです。''',
  ),
  LetterSample(
    id: 'apology_missed_event',
    category: LetterCategory.apology,
    title: '欠席のお詫び',
    description: '出席できなかったことへのお詫びの手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

このたびは、大切な会にお伺いできず、申し訳ございませんでした。

やむを得ない事情とはいえ、当日の様子を後から伺い、ご一緒できなかったことを残念に思っております。

改めてお祝いの気持ちをお伝えできればと思っております。

今後ともどうぞよろしくお願いいたします。''',
  ),

  // --- お見舞い --------------------------------------------------------
  LetterSample(
    id: 'sympathy_hospital',
    category: LetterCategory.sympathy,
    title: '入院のお見舞い',
    description: '入院された方を気遣う手紙です。',
    style: WritingStyle.soft,
    body: '''○○様

体調を崩されたと伺い、大変驚いております。

日頃お元気な○○様のことですので、きっとすぐに良くなられることと思いますが、どうか無理をなさらず、ゆっくりと療養なさってください。

一日も早いご回復を、心よりお祈り申し上げます。''',
  ),
  LetterSample(
    id: 'sympathy_disaster',
    category: LetterCategory.sympathy,
    title: '災害見舞い',
    description: '被災された方を気遣う手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

このたびの災害により被害を受けられたと伺い、心よりお見舞い申し上げます。

ご無事とのこと、まずは安堵しております。しかし、ご不便な生活が続いているかと存じ、案じております。

何かお力になれることがあれば、どうぞ遠慮なくお申し付けください。

一日も早い復旧を心よりお祈り申し上げます。''',
  ),
  LetterSample(
    id: 'sympathy_recovery',
    category: LetterCategory.sympathy,
    title: '快気祝いへの返礼',
    description: '見舞いへのお礼と回復の報告をする手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

先日は、入院中のお見舞いをいただき、誠にありがとうございました。

おかげさまで無事に退院し、少しずつ普段の生活を取り戻しております。

温かいお心遣いに、心より感謝申し上げます。

今後ともどうぞよろしくお願いいたします。''',
  ),

  // --- 挨拶 ------------------------------------------------------------
  LetterSample(
    id: 'greeting_new_year',
    category: LetterCategory.greeting,
    title: '新年のご挨拶',
    description: '新年を迎えたご挨拶の手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

謹んで新年のお慶びを申し上げます。

旧年中は大変お世話になり、心より御礼申し上げます。

本年も変わらぬお付き合いのほど、よろしくお願い申し上げます。

皆様にとって、健やかで実り多い一年となりますよう、心よりお祈り申し上げます。''',
  ),
  LetterSample(
    id: 'greeting_moving',
    category: LetterCategory.greeting,
    title: '引っ越しのご挨拶',
    description: '新しい住まいへの引っ越しを知らせる手紙です。',
    style: WritingStyle.soft,
    body: '''○○様

このたび、○○へ引っ越すこととなりました。

これまでのご近所付き合い、本当にありがとうございました。おかげさまで、楽しい日々を過ごすことができました。

新しい場所でも変わらず元気に過ごしてまいりますので、機会がありましたら、ぜひ遊びにいらしてください。

これからもどうぞよろしくお願いいたします。''',
  ),
  LetterSample(
    id: 'greeting_new_position',
    category: LetterCategory.greeting,
    title: '着任のご挨拶',
    description: '新しい部署・役職への着任を知らせる手紙です。',
    style: WritingStyle.veryPolite,
    body: '''○○様

拝啓　このたび、○月○日付けにて○○の任を拝することとなりました。

浅学非才の身ではございますが、皆様のお力添えをいただきながら、精一杯努めてまいる所存です。

至らぬ点も多々あるかと存じますが、何卒ご指導ご鞭撻のほど、よろしくお願い申し上げます。

敬具''',
  ),

  // --- ビジネス --------------------------------------------------------
  LetterSample(
    id: 'business_thanks_meeting',
    category: LetterCategory.business,
    title: '打ち合わせのお礼',
    description: '商談・打ち合わせ後に送るお礼状です。',
    style: WritingStyle.veryPolite,
    body: '''○○株式会社
○○様

拝啓　貴社ますますご清栄のこととお慶び申し上げます。

本日は、お忙しい中お時間を頂戴し、誠にありがとうございました。貴重なお話を伺うことができ、大変勉強になりました。

お伺いした内容を踏まえ、改めて検討のうえご連絡させていただきます。

今後ともよろしくお願い申し上げます。

敬具''',
  ),
  LetterSample(
    id: 'business_new_year',
    category: LetterCategory.business,
    title: '年始のご挨拶（取引先）',
    description: '取引先へ送る年始のビジネス挨拶状です。',
    style: WritingStyle.veryPolite,
    body: '''○○株式会社
○○様

謹んで新春のお慶びを申し上げます。

平素は格別のご高配を賜り、厚く御礼申し上げます。

本年も社員一同、より一層のご満足をいただけるよう努めてまいります。

倍旧のお引き立てを賜りますよう、お願い申し上げます。''',
  ),
  LetterSample(
    id: 'business_referral_thanks',
    category: LetterCategory.business,
    title: 'ご紹介のお礼',
    description: '取引先の紹介をいただいたことへのお礼です。',
    style: WritingStyle.veryPolite,
    body: '''○○様

このたびは、貴重なお取引先をご紹介いただき、誠にありがとうございます。

○○様のご厚意により、新たなご縁をいただけましたこと、心より感謝申し上げます。

ご期待に沿えるよう、誠心誠意対応させていただく所存です。

今後ともご指導のほど、よろしくお願い申し上げます。''',
  ),

  // --- 季節の便り --------------------------------------------------------
  LetterSample(
    id: 'seasonal_mothers_day',
    category: LetterCategory.seasonal,
    title: '母の日',
    description: '母の日に感謝の気持ちを伝える手紙です。',
    style: WritingStyle.soft,
    body: '''お母さんへ

いつもありがとう。

小さい頃からずっと、私のことを見守ってくれて、本当に感謝しています。当たり前だと思っていたことのひとつひとつが、実はとても大きな愛情だったのだと、今になって気づかされます。

これからは、私がお母さんを支えられる存在になれたらと思っています。

いつまでも元気でいてね。''',
  ),
  LetterSample(
    id: 'seasonal_midsummer',
    category: LetterCategory.seasonal,
    title: '暑中見舞い',
    description: '夏の時候の挨拶を伝える手紙です。',
    style: WritingStyle.polite,
    body: '''暑中お見舞い申し上げます。

厳しい暑さが続いておりますが、お変わりなくお過ごしでしょうか。

日頃のご無沙汰をお詫びするとともに、皆様のご健勝を心よりお祈り申し上げます。

まだまだ暑い日が続きますので、どうぞご自愛くださいませ。''',
  ),
  LetterSample(
    id: 'seasonal_year_end',
    category: LetterCategory.seasonal,
    title: '年末のご挨拶',
    description: '一年の感謝を伝える年末の手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

本年も残りわずかとなりました。

この一年、大変お世話になり、心より御礼申し上げます。おかげさまで、穏やかな気持ちで年を越すことができそうです。

来る年も、皆様にとって良い一年になりますよう、心よりお祈り申し上げます。

どうぞよいお年をお迎えください。''',
  ),

  // --- その他 --------------------------------------------------------
  LetterSample(
    id: 'other_encouragement',
    category: LetterCategory.other,
    title: '応援のメッセージ',
    description: '挑戦する人を励ます手紙です。',
    style: WritingStyle.soft,
    body: '''○○さんへ

新しい一歩を踏み出す○○さんのことを、心から応援しています。

不安なこともあるかもしれませんが、これまでの○○さんの頑張りを、私はずっと見てきました。きっと大丈夫です。

離れていても、いつでも応援しています。無理せず、自分のペースで進んでくださいね。''',
  ),
  LetterSample(
    id: 'other_thank_you_gift',
    category: LetterCategory.other,
    title: '贈り物のお礼',
    description: '思いがけない贈り物へのお礼の手紙です。',
    style: WritingStyle.polite,
    body: '''○○様

このたびは、思いがけず素敵なお品をお贈りいただき、誠にありがとうございます。

お心遣いに、家族一同大変喜んでおります。

ささやかではございますが、御礼のご挨拶を申し上げます。

今後ともどうぞよろしくお願いいたします。''',
  ),
];
