{ldelim}extends file="Master.tpl"{rdelim}

{ldelim}block name=title{rdelim}{$appname} | {$plural}{ldelim}/block{rdelim}

{ldelim}block name=customHeader{rdelim}
<script type="text/javascript">
	$LAB.script("scripts/app/{$plural|lower}.js").wait(function(){
		$(document).ready(function(){
			page.init();
		});

		// hack for IE9 which may respond inconsistently with document.ready
		setTimeout(function(){
			if (!page.isInitialized) page.init();
		},1000);
	});
</script>
{ldelim}/block{rdelim}


{block name=content}

	<script type="text/template" id="{$singular|lcfirst}ModelTemplate">
		<form class="form-horizontal" onsubmit="return false;">
			<fieldset>
{foreach from=$table->Columns item=column name=columnsForEach}
				<div id="{$column->NameWithoutPrefix|studlycaps|lcfirst}InputContainer" class="control-group">
					<label class="control-label" for="{$column->NameWithoutPrefix|studlycaps|lcfirst}">{$column->NameWithoutPrefix|underscore2space}</label>
					<div class="controls inline-inputs">
{if $column->Extra == 'auto_increment'}
						<span class="input-xlarge uneditable-input" id="{$column->NameWithoutPrefix|studlycaps|lcfirst}"><%= _.escape(item.get('{$column->NameWithoutPrefix|studlycaps|lcfirst}') || '') %></span>
{elseif $column->Key == "MUL" && $column->Constraints}
						<select id="{$column->NameWithoutPrefix|studlycaps|lcfirst}" name="{$column->NameWithoutPrefix|studlycaps|lcfirst}"></select>
{elseif $column->IsEnum()}
						<select id="{$column->NameWithoutPrefix|studlycaps|lcfirst}" name="{$column->NameWithoutPrefix|studlycaps|lcfirst}">
							<option value=""></option>
{foreach from=$column->GetEnumValues() item=enumVal name=enumValForEach}
							<option value="{$enumVal|escape}"<% if (item.get('{$column->NameWithoutPrefix|studlycaps|lcfirst}')=='{$enumVal|escape}') { %> selected="selected"<% } %>>{$enumVal|escape}</option>
{/foreach}
						</select>
{elseif $column->Type == "date" || $column->Type == "datetime" || $column->Type == "timestamp"}
						<div class="input-append date date-picker" data-date-format="yyyy-mm-dd">
							<input id="{$column->NameWithoutPrefix|studlycaps|lcfirst}" type="text" value="<%= _date(app.parseDate(item.get('{$column->NameWithoutPrefix|studlycaps|lcfirst}'))).format('YYYY-MM-DD') %>" />
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
{if $column->Type == "datetime" || $column->Type == "timestamp"}
						<div class="input-append bootstrap-timepicker-component">
							<input id="{$column->NameWithoutPrefix|studlycaps|lcfirst}-time" type="text" class="timepicker-default input-small" value="<%= _date(app.parseDate(item.get('{$column->NameWithoutPrefix|studlycaps|lcfirst}'))).format('h:mm A') %>" />
							<span class="add-on"><i class="icon-time"></i></span>
						</div>
{/if}
{elseif $column->Type == 'time'}
						<div class="input-append bootstrap-timepicker-component">
							<input id="{$column->NameWithoutPrefix|studlycaps|lcfirst}" type="text" class="timepicker-default input-small" value="<%= _date(app.parseDate(item.get('{$column->NameWithoutPrefix|studlycaps|lcfirst}'))).format('h:mm A') %>" />
							<span class="add-on"><i class="icon-time"></i></span>
						</div>
{elseif $column->Type == 'text' || $column->Type == 'tinytext' || $column->Type == 'mediumtext' || $column->Type == 'longtext'}
						<textarea class="input-xlarge" id="{$column->NameWithoutPrefix|studlycaps|lcfirst}" rows="3"><%= _.escape(item.get('{$column->NameWithoutPrefix|studlycaps|lcfirst}') || '') %></textarea>
{elseif false}
						<select id="{$column->NameWithoutPrefix|studlycaps|lcfirst}"><option>something</option><option>2</option></select>
{else}
						<input type="text" class="input-xlarge" id="{$column->NameWithoutPrefix|studlycaps|lcfirst}" placeholder="{$column->NameWithoutPrefix|underscore2space}" value="<%= _.escape(item.get('{$column->NameWithoutPrefix|studlycaps|lcfirst}') || '') %>" />
{/if}
						<span class="help-inline"></span>
					</div>
				</div>
{/foreach}
			</fieldset>
		</form>

		<!-- delete button is is a separate form to prevent enter key from triggering a delete -->
		<form id="delete{$singular}ButtonContainer" class="form-horizontal" onsubmit="return false;">
			<fieldset>
				<div class="control-group">
					<label class="control-label"></label>
					<div class="controls">
						<button id="delete{$singular}Button" class="btn btn-mini btn-danger"><i class="icon-trash icon-white"></i> Delete {$singular}</button>
						<span id="confirmDelete{$singular}Container" class="hide">
							<button id="cancelDelete{$singular}Button" class="btn btn-mini">Cancel</button>
							<button id="confirmDelete{$singular}Button" class="btn btn-mini btn-danger">Confirm</button>
						</span>
					</div>
				</div>
			</fieldset>
		</form>
	</script>

{/block}