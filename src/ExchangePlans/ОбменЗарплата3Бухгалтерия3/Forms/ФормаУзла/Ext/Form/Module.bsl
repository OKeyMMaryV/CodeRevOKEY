﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Элементы.Наименование.Видимость = Ложь;
		Элементы.Служебные.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
	КонецЕсли;
	
	РежимСинхронизацииОрганизаций = ?(Объект.ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
	РежимВыгрузкиСотрудников = ?(Объект.НеВыгружатьПерсональныеДанныеФизическихЛиц,1,0);
	
	Организации.Загрузить(ВсеОрганизацииПриложения());
	
	ОтметитьВыбранныеЭлементыТаблицы("Организации", "Организация");
	
	ЗначениеВыгружатьВсегда = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВсегда;
	ЗначениеВыгружатьПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаНачалаИспользованияОбмена", "МесяцНачалаЭксплуатацииСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ИспользоватьОтборПоОрганизациям = (РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	Если ТекущийОбъект.ИспользоватьОтборПоОрганизациям Тогда
		ТекущийОбъект.Организации.Загрузить(Организации.Выгрузить(Новый Структура("Использовать", Истина), "Организация"));
	Иначе
		ТекущийОбъект.Организации.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Организации");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтаФорма[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ВсеОрганизацииПриложения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Использовать,
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Процедура ОтметитьВыбранныеЭлементыТаблицы(ИмяТаблицы, ИмяРеквизита)
	
	Для Каждого СтрокаТаблицы Из Объект[ИмяТаблицы] Цикл
		
		Строки = ЭтаФорма[ИмяТаблицы].НайтиСтроки(Новый Структура(ИмяРеквизита, СтрокаТаблицы[ИмяРеквизита]));
		
		Если Строки.Количество() > 0 Тогда
			
			Строки[0].Использовать = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзмененииЗначения()
	
	Элементы.Организации.Доступность =
		(РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимВыгрузкиСотрудниковПриИзменении(Элемент)
	
	Объект.НеВыгружатьПерсональныеДанныеФизическихЛиц = ?(РежимВыгрузкиСотрудников = 0, Ложь, Истина);
	
	Если Объект.НеВыгружатьПерсональныеДанныеФизическихЛиц Тогда
		Объект.РежимВыгрузкиПерсональныеДанные = ЗначениеВыгружатьПриНеобходимости;
	Иначе
		Объект.РежимВыгрузкиПерсональныеДанные = ЗначениеВыгружатьВсегда;
	КонецЕсли;
	
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура МесяцНачалаЭксплуатацииСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаНачалаИспользованияОбмена", "МесяцНачалаЭксплуатацииСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаЭксплуатацииСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаНачалаИспользованияОбмена", "МесяцНачалаЭксплуатацииСтрокой", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаЭксплуатацииСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаНачалаИспользованияОбмена", "МесяцНачалаЭксплуатацииСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаЭксплуатацииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаЭксплуатацииСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры


#КонецОбласти

#КонецОбласти
