﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	// Ограничим список выбора, для того чтобы пользователь мог выбрать виды эд только первичных титулов.
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	// фнс
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ТОРГ12Продавец);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.АктИсполнитель);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.АктНаПередачуПрав);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.СчетФактура);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.КорректировочныйСчетФактура);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиОтправитель);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.АктОРасхождениях);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.УПД);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.УКД);
	
	// cml
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.СчетНаОплату);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ЗаказТовара);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ОтветНаЗаказ);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ПрайсЛист);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ОтчетОПродажахКомиссионногоТовара);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ОтчетОСписанииКомиссионногоТовара);
	
	// BNCommerceOffering
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ЗапросКоммерческихПредложений);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.КоммерческоеПредложение);
	
	// прочее
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ПроизвольныйЭД);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ПередачаТоваровМеждуОрганизациями);
	ДанныеВыбора.Добавить(Перечисления.ВидыЭД.ВозвратТоваровМеждуОрганизациями);
	
КонецПроцедуры

#КонецОбласти

