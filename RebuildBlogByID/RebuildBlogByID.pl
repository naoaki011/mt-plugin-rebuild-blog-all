package MT::Plugin::RebuildBlogByID;
use strict;
use MT;
require MT::Plugin;
# use MT::Util qw ( start_background_task );

our $VERSION = '1.0';

use base qw( MT::Plugin );

###################################### Init Plugin #####################################

my $plugin = MT::Plugin::RebuildBlogByID->new({
    id => 'RebuildBlogByID',
    key => 'rebuildblogbyid',
    name => 'RebuildBlogByID',
    description => '<MT_TRANS phrase=\'_PLUGIN_DESCRIPTION\'>',
    author_name => 'okayama',
    author_link => 'http://weeeblog.net/',
    'version' => $VERSION,
    l10n_class => 'RebuildBlogByID::L10N',
    blog_config_template => 'rebuildblogbyid.tmpl',
    settings => new MT::PluginSettings([
        ['selected_blog_id', { Default => '' }],
    ]),
});

MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'cms_post_save.entry',
                => \&_post_save_entry,
            'api_post_save.entry',
                => \&_post_save_entry,
            'MT::App::CMS::template_source.rebuildblogbyid',
                => \&_cb_template_source_rebuildblogbyid,
        },
   });
}

######################################### Mainroutine #########################################

sub _post_save_entry {
	my ( $eh, $app, $obj, $original ) = @_;
	my $blog_id;
	if ( $obj->class eq 'entry' ) {
		$blog_id = $plugin->get_config_value( 'selected_blog_id', 'blog:' . $obj->blog_id ) || $obj->blog_id;
	}
	$app = MT->instance;
	if ( $app && $blog_id) {
		require MT::Blog;
		my $blog = MT::Blog->load( { id => $blog_id } );
		if ( $blog && ( $blog->theme_id =~ /jsaastheme_[abc]0[123]/ ) ) {
			MT::Util::start_background_task( sub { 
											if ( $app->rebuild( BlogID => $blog_id ) ) {
												$app->log( $plugin->translate( 'Rebuild Blog [_1]', $blog->name ) );
											}
										});
		}
	}
1;
}

######################################## callbacks ########################################

# MT::App::CMS::template_source.rebuildblogbyid
# add select menu
sub _cb_template_source_rebuildblogbyid {
    my ( $cb, $app, $tmpl ) = @_;
    my $blog_id = $plugin->get_config_value('selected_blog_id', 'blog:' . $app->blog->id);
    use MT::Blog;
    my @blogs = MT::Blog->load;
    my $src = '<select name="selected_blog_id">' . "\n";
    foreach my $blog (@blogs) {
        if ( $blog->theme_id =~ /jsaastheme_[abc]0[123]/ ) {
            if ($blog_id eq $blog->id) {
                $src .= '<option value="' . $blog->id . '" selected="selected">' . $blog->name . '</option>' . "\n";
            } else {
                $src .= '<option value="' . $blog->id . '">' . $blog->name . '</option>' . "\n";
            }
        }
    }
    $src .= '</select>' . "\n";
    $$tmpl =~ s/\*selected_blog_id\*/$src/sg;
}

sub doLog {
    my ($msg) = @_; 
    return unless defined($msg);
    require MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}


1;