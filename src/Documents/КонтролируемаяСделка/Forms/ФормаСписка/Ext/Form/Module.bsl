﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура УведомлениеОКонтролируемыхСделкахПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено( УведомлениеОКонтролируемыхСделках) Тогда
		Список.Отбор.Элементы.Очистить();
		ОтборПоУведомлению = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоУведомлению.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УведомлениеОКонтролируемойСделке");
		ОтборПоУведомлению.ПравоеЗначение = УведомлениеОКонтролируемыхСделках;
		Элементы.УведомлениеОКонтролируемойСделке.Видимость = Ложь;
		ПроверитьКорректностьНомеров();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УведомлениеОКонтролируемыхСделкахОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Список.Отбор.Элементы.Очистить();
	УведомлениеОКонтролируемыхСделках = УведомлениеОКонтролируемыхСделках.Пустая();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если НЕ ЗначениеЗаполнено(УведомлениеОКонтролируемыхСделках) И
		Параметры.Свойство("УведомлениеОКонтролируемыхСделках") Тогда
		УведомлениеОКонтролируемыхСделках = Параметры.УведомлениеОКонтролируемыхСделках;
	КонецЕсли;
	
	Элементы.ДекорацияОтборПоУведомлению.Заголовок = 
		КонтролируемыеСделки.ПредставлениеУведомления(УведомлениеОКонтролируемыхСделках, НСтр("ru = 'Листы 1А'"));
	
	УведомлениеУказано = ЗначениеЗаполнено(УведомлениеОКонтролируемыхСделках);
	
	Элементы.УведомлениеОКонтролируемыхСделках.Видимость = НЕ УведомлениеУказано;
	Элементы.УведомлениеОКонтролируемойСделке.Видимость = НЕ УведомлениеУказано;
	Элементы.ДекорацияОтборПоУведомлению.Видимость = УведомлениеУказано;
	
	Если ЗначениеЗаполнено(УведомлениеОКонтролируемыхСделках) Тогда
		Список.Порядок.Элементы.Очистить();
		ПорядокСписка = Список.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("Номер");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
	КонецЕсли;
	
	ПроверитьКорректностьНомеров();

	УстановитьУсловноеОформление();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.КонтролируемаяСделка);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
КонецПроцедуры

&НаСервере
Процедура ПеренумероватьДокументыНаСервере()
	
	КонтролируемыеСделки.ПеренумерацияКонтролируемыхСделокУведомления(УведомлениеОКонтролируемыхСделках);
	
КонецПроцедуры	

&НаКлиенте
Процедура ВопросПеренумероватьЛистыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренумероватьДокументыНаСервере();
		ПоказатьПредупреждение( , НСтр("ru = 'Листы 1А пронумерованы'"));
		НомераКонтролируемыхСделокКорректны = Истина;
		РекомендуетсяПеренумероватьДокументы =  НСтр("ru = 'Нумерация листов 1А корректна'");
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренумероватьДокументы(Команда)
	
	Перенумеровать = Истина;
	ПроверитьКорректностьНомеров();
	Если НомераКонтролируемыхСделокКорректны Тогда
		ТекстВопроса = Нстр("ru = 'Нумерация листов 1А по текущему уведомлению корректна.#РазделительСтрок#Все равно перенумеровать листы?#РазделительСтрок#(операция может занять продолжительное время)'");
		Оповещение = Новый ОписаниеОповещения("ВопросПеренумероватьЛистыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение,СтрЗаменить(ТекстВопроса, "#РазделительСтрок#", Символы.ПС), РежимДиалогаВопрос.ДаНет);	
	Иначе
		ВопросПеренумероватьЛистыЗавершение(КодВозвратаДиалога.Да, Новый Структура);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "НомерКонтролируемойСделкиИзменился" Тогда
		Если Параметр = УведомлениеОКонтролируемыхСделках Тогда
			ПроверитьКорректностьНомеров();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьКорректностьНомеров()
	
	НомераКонтролируемыхСделокКорректны = КонтролируемыеСделки.НомераКонтролируемыхСделокУведомленияКоректны(УведомлениеОКонтролируемыхСделках);
	РекомендуетсяПеренумероватьДокументы = ?(НЕ НомераКонтролируемыхСделокКорректны, НСтр("ru = 'Нумерация листов 1А не корректна'"), НСтр("ru = 'Нумерация листов 1А корректна'"));
	
КонецПроцедуры	

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// НадписьРекомендуетсяПеренумероватьДокументы

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НадписьРекомендуетсяПеренумероватьДокументы");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"НомераКонтролируемыхСделокКорректны", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);

КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
