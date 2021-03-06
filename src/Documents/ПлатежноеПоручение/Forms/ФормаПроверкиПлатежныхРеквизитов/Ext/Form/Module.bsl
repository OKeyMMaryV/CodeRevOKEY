
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.ПлатежныеРеквизиты) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Контрагент) Тогда
		Контрагент = Параметры.Контрагент;
	ИначеЕсли ЗначениеЗаполнено(Параметры.БанковскийСчет) Тогда
		Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.БанковскийСчет, "Владелец");
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Реквизиты = ДанныеГосударственныхОрганов.ПолучитьПлатежныеРеквизитыКонтрагента(Контрагент);
	ПлатежныеРеквизитыДокумента = Параметры.ПлатежныеРеквизиты;
	
	Если Реквизиты.Вид = Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган Тогда
		Элементы.ДекорацияПредупреждение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияПредупреждение.Заголовок, НСтр("ru = 'своей налоговой инспекции'"));
	ИначеЕсли Реквизиты.Вид = Перечисления.ВидыГосударственныхОрганов.ОрганПФР Тогда
		Элементы.ДекорацияПредупреждение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияПредупреждение.Заголовок, НСтр("ru = 'своем отделении ПФР'"));
	ИначеЕсли Реквизиты.Вид = Перечисления.ВидыГосударственныхОрганов.ОрганФСС Тогда
		Элементы.ДекорацияПредупреждение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияПредупреждение.Заголовок, НСтр("ru = 'своем отделении ФСС'"));
	Иначе
		Элементы.ДекорацияПредупреждение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияПредупреждение.Заголовок, НСтр("ru = 'своем отделении гос.органа'"));
	КонецЕсли;
	
	ДобавитьПлатежныйРеквизит(НСтр("ru = ''"), НСтр("ru = 'В документе'"), НСтр("ru = 'Рекомендуемое значение'"));
	ДобавитьПлатежныйРеквизит(НСтр("ru = 'Получатель платежа'"), 
			ПлатежныеРеквизитыДокумента.ПолучательПлатежа, 
			Реквизиты.ПлатежныеРеквизиты.ПолучательПлатежа);
	ДобавитьПлатежныйРеквизит(НСтр("ru = 'ИНН'"),
			ПлатежныеРеквизитыДокумента.ИНН, 
			Реквизиты.ИНН);
	ДобавитьПлатежныйРеквизит(НСтр("ru = 'КПП'"),
			ПлатежныеРеквизитыДокумента.КПП, 
			Реквизиты.КПП);
	ДобавитьПлатежныйРеквизит(НСтр("ru = 'Расчетный счет'"),
			ПлатежныеРеквизитыДокумента.РасчетныйСчет, 
			Реквизиты.ПлатежныеРеквизиты.РасчетныйСчет);
	ДобавитьПлатежныйРеквизит(НСтр("ru = 'БИК'"),
			ПлатежныеРеквизитыДокумента.БИК, 
			Реквизиты.ПлатежныеРеквизиты.БИК);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПлатежныеРеквизитыИмяРеквизита.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПлатежныеРеквизитыЗначениеРеквизитаДокумента.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПлатежныеРеквизитыЗначениеРеквизита.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПлатежныеРеквизиты.ПлатежныеРеквизитыОтличаются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	КрасныйЦвет = Новый Цвет(251, 212, 212);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", КрасныйЦвет);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПлатежныйРеквизит(ИмяРеквизита, РеквизитДокумента, Реквизит)
	
	ПлатежныйРеквизит = ПлатежныеРеквизиты.Добавить();
	ПлатежныйРеквизит.ИмяРеквизита               = ИмяРеквизита;
	ПлатежныйРеквизит.ЗначениеРеквизитаДокумента = РеквизитДокумента;
	ПлатежныйРеквизит.ЗначениеРеквизита          = Реквизит;
	Если ЗначениеЗаполнено(ИмяРеквизита) Тогда
		ПлатежныйРеквизит.ПлатежныеРеквизитыОтличаются = ПлатежныйРеквизит.ЗначениеРеквизитаДокумента <> ПлатежныйРеквизит.ЗначениеРеквизита;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПлатежныеРеквизиты()
	
	Если НЕ ДанныеГосударственныхОрганов.ПлатежныеРеквизитыАктуальны(Реквизиты) Тогда
		ДанныеГосударственныхОрганов.ОбновитьДанныеГосударственногоОргана(Реквизиты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодставитьРекомендуемыеЗначения(Команда)
	
	ЗаписатьПлатежныеРеквизиты();
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ПерезаполнитьКонтрагента", Истина);
	ВозвращаемоеЗначение.Вставить("Контрагент", Реквизиты.Ссылка);
	ВозвращаемоеЗначение.Вставить("СчетКонтрагента", Реквизиты.ПлатежныеРеквизиты.БанковскийСчет);
	Закрыть(ВозвращаемоеЗначение);
	
КонецПроцедуры
