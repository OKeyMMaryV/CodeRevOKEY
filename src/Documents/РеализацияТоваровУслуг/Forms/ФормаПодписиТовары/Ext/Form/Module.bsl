﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполним реквизиты формы из параметров.
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,
		"Организация, Контрагент, 
		|ОтпускПроизвел, Руководитель, ЗаРуководителяНаОсновании,
		|ГлавныйБухгалтер, ЗаГлавногоБухгалтераНаОсновании,
		|ОтпускПроизвел,
		|ДатаДокумента, ЗаЗаказчикаНаОсновании,ОтветственныйЗаОформление,
		|ДоверенностьВыдана, ДоверенностьДата, ДоверенностьНомер, ДоверенностьЧерезКого
		//izhtc alena 19.08.2015( 
		|,ДатаПередачиДокументов
		//izhtc alena 19.08.2015)		
		|");
	
	ПолноеНаименованиеКонтрагента = ?(ЗначениеЗаполнено(Контрагент), 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "НаименованиеПолное"), "");
	
	Если ЗначениеЗаполнено(ПолноеНаименованиеКонтрагента) Тогда
		Элементы.ДоверенностьВыдана.СписокВыбора.Добавить(ПолноеНаименованиеКонтрагента);
	КонецЕсли;
	
	Элементы.ЗаЗаказчикаНаОсновании.Видимость = Параметры.ДоступноОформлениеУслуг;
	
	СписокКонтактныхЛиц = Справочники.КонтактныеЛица.СписокКонтактныхЛиц(Контрагент);
	Для Каждого ЭлементСписка Из СписокКонтактныхЛиц Цикл
		Элементы.ДоверенностьЧерезКого.СписокВыбора.Добавить(ЭлементСписка.Представление);
	КонецЦикла;
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Документ.РеализацияТоваровУслуг",
		"ФормаРеквизитыОрганизацииКонтрагентаТовары",
		НСтр("ru='Новости: Реализация (акт, накладная)'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВДокумент И Модифицированность Тогда
		СтруктураРезультат = Новый Структура("
			|Руководитель, ЗаРуководителяНаОсновании,
			|ГлавныйБухгалтер, ЗаГлавногоБухгалтераНаОсновании,
			|ОтпускПроизвел, ЗаЗаказчикаНаОсновании,
			|ДоверенностьНомер, ДоверенностьДата,ОтветственныйЗаОформление,
			|ДоверенностьВыдана, ДоверенностьЧерезКого
			//izhtc alena 19.08.2015( 
			|,ДатаПередачиДокументов
			//izhtc alena 19.08.2015)
			|");
			
		ЗаполнитьЗначенияСвойств(СтруктураРезультат, ЭтаФорма);
		
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоверенностьЧерезКогоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Список = СписокКонтактныхЛицКонтрагента(Контрагент);
	
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаДоверенностьЧерезКогоЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, Список, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	
	ЗаРуководителяНаОсновании = ПолучитьОснованиеПраваПодписиФизЛица(Руководитель,Организация,ДатаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
		
	ЗаГлавногоБухгалтераНаОсновании = ПолучитьОснованиеПраваПодписиФизЛица(ГлавныйБухгалтер,Организация,ДатаДокумента);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры


#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьОснованиеПраваПодписиФизЛица(ФизическоеЛицо,Организация,ДатаОтбор)
	
	Возврат Справочники.ОснованияПраваПодписи.ОснованиеПраваПодписиФизЛица(ФизическоеЛицо,Организация,ДатаОтбор);
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокКонтактныхЛицКонтрагента(Знач Контрагент)
	
	Возврат Справочники.КонтактныеЛица.СписокКонтактныхЛиц(Контрагент);
	
КонецФункции

&НаКлиенте
Процедура ВыборИзСпискаДоверенностьЧерезКогоЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		ДоверенностьЧерезКого = РезультатВыбора.Представление;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 
