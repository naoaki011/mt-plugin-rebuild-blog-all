package RebuildBlogByID::L10N::ja;

use strict;
use base qw/ RebuildBlogByID::L10N MT::L10N MT::Plugin::L10N /;
use vars qw( %Lexicon );

our %Lexicon = (
    '_PLUGIN_DESCRIPTION' => &_plugin_description,
#    'Rebuild Blog ID at saving pages' => 'ウェブページ保存の際に再構築するブログの ID',
#    'Rebuild Blog ID at saving entries' => 'ブログ記事保存の際に再構築するブログの ID',
#    'Rebuild Blog ID at saving pages by API' => 'API でのウェブページ保存の際に再構築するブログの ID',
#    'Rebuild Blog ID at saving entries by API' => 'API でのブログ記事保存の際に再構築するブログの ID',
    'Rebuild Blog [_1]' => 'ブログ [_1] を再構築しました',
    'Blog.' => 'ブログ',
    'Settings of Blogs.' => 'ブログに関する設定',
    );

sub _plugin_description {
    return<<'TEXT';
ブログ記事<del>またはウェブページ</del>が保存された際に、プラグイン設定で指定したブログを再構築します。<br />
各ブログのプラグイン設定で、再構築したいブログの <del>ID を半角数字カンマ区切りで入力してください(例: 1,2,3)。</del>ブログ名をプルダウンから選択して指定します。<br />
mt-config.cgi に環境変数 <a href="http://www.movabletype.jp/documentation/appendices/config-directives/launchbackgroundtasks.html">LaunchBackGroundTasks</a> を設定しておけば再構築をバックグラウンドで行わせることができるので、見た目上の負荷は変わりません。<br />
TEXT
}

1;
