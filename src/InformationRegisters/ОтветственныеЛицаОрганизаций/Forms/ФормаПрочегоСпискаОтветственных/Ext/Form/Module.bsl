﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Организация = Параметры.Отбор.СтруктурнаяЕдиница;
	
	ДатаСреза = ТекущаяДата();
	
	ОбновитьОтветственныхЛиц();
	
	Элементы.ОтветственныйЗаБухгалтерскиеРегистры.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ОтветственныйЗаБухгалтерскиеРегистрыДолжность.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ОтветственныйЗаНалоговыеРегистры.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ОтветственныйЗаНалоговыеРегистрыДолжность.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.Исполнитель.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ИсполнительДолжность.ТолькоПросмотр = ТолькоПросмотр;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйЗаБухгалтерскиеРегистрыДолжностьПриИзменении(Элемент)
	
	ИзмененОтветственныйЗаБР = истина;
	
	ЭтотОбъект.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаНалоговыеРегистрыДолжностьПриИзменении(Элемент)
	
	ИзмененОтветственныйЗаНР = истина;
	
	ЭтотОбъект.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительДолжностьПриИзменении(Элемент)
	
	ИзмененИсполнитель = истина;
	
	ЭтотОбъект.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаБухгалтерскиеРегистрыПриИзменении(Элемент)
	
	ИзмененОтветственныйЗаБР = истина;
	
	ЭтотОбъект.Модифицированность = Истина;
	
	Если ЗначениеЗаполнено(ОтветственныйЗаБухгалтерскиеРегистрыФизЛицо) тогда
		
		ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Организация, ОтветственныйЗаБухгалтерскиеРегистрыФизЛицо, ТекущаяДата());
		ОтветственныйЗаБухгалтерскиеРегистрыДолжность = ДанныеФизЛица.Должность;
		
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаНалоговыеРегистрыПриИзменении(Элемент)
	
	ИзмененОтветственныйЗаНР = истина;
	
	ЭтотОбъект.Модифицированность = Истина;
	
	Если ЗначениеЗаполнено(ОтветственныйЗаНалоговыеРегистрыФизЛицо) тогда
		
		ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Организация, ОтветственныйЗаНалоговыеРегистрыФизЛицо, ТекущаяДата());
		ОтветственныйЗаНалоговыеРегистрыДолжность = ДанныеФизЛица.Должность;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	ИзмененИсполнитель = истина;
	
	ЭтотОбъект.Модифицированность = Истина;
	
	Если ЗначениеЗаполнено(ИсполнительФизЛицо) тогда
		
		ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Организация, ИсполнительФизЛицо, ТекущаяДата());
		ИсполнительДолжность = ДанныеФизЛица.Должность;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияБухгалтерскиеРегистрыИсторияНажатие(Элемент)
	
	ДекорацияИсторияНажатие(Элемент,"ОтветственныйЗаБухгалтерскиеРегистры");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНалоговыеРегистрыИсторияНажатие(Элемент)
	
	ДекорацияИсторияНажатие(Элемент,"ОтветственныйЗаНалоговыеРегистры");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтчетностьСтатистикаИсторияНажатие(Элемент)
	
	ДекорацияИсторияНажатие(Элемент,"Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИсторияНажатие(Элемент,РольОтветственногоЛица)
	Перем ОтветственноеЛицо;
	
	ОтветственноеЛицо	= ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций."+РольОтветственногоЛица);
	
	Отбор	= Новый Структура("СтруктурнаяЕдиница,ОтветственноеЛицо",
	Организация,
	ОтветственноеЛицо);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДекорацияИсторияНажатиеЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор",	Отбор);
	ПараметрыФормы.Вставить("ТолькоПросмотр",	ТолькоПросмотр);
	
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.Форма.ФормаИстории", ПараметрыФормы, Элемент,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаБухгалтерскиеРегистрыДолжностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаБухгалтерскиеРегистрыДолжностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьОкончаниеВводаТекста(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаБухгалтерскиеРегистрыДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаНалоговыеРегистрыДолжностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаНалоговыеРегистрыДолжностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьОкончаниеВводаТекста(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаНалоговыеРегистрыДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительДолжностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительДолжностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьОкончаниеВводаТекста(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСДолжностямиБПКлиент.ДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьОтветственныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ЗаписатьОтветственныхНаСервере();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДекорацияИсторияНажатиеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ОбновитьОтветственныхЛиц();
	
КонецПроцедуры

&Насервере
Процедура ОбновитьОтветственныхЛиц()
	
	
	ОтветственныйЗаБухгалтерскиеРегистрыКлючЗаписи		= РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч();
	ОтветственныйЗаНалоговыеРегистрыКлючЗаписи			= РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч();
	ИсполнительКлючЗаписи								= РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч();
	
	
	Запрос	= Новый Запрос;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",	Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтветственныеЛицаОрганизацийСрезПоследних.Период КАК Период,
	|	ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	(ОтветственныеЛицаОрганизацийСрезПоследних.Должность) КАК Должность,
	|	(ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо) КАК ФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры)
	|			ТОГДА ""ОтветственныйЗаБухгалтерскиеРегистры""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ОтветственныйЗаНалоговыеРегистры)
	|			ТОГДА ""ОтветственныйЗаНалоговыеРегистры""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Исполнитель)
	|			ТОГДА ""Исполнитель""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ПредставлениеОтветственногоЛица
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних КАК ОтветственныеЛицаОрганизацийСрезПоследних
	|ГДЕ
	|	ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И (ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры)
	|			ИЛИ ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ОтветственныйЗаНалоговыеРегистры)
	|			ИЛИ ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Исполнитель))";
	
	Отбор = Новый Структура("Период, СтруктурнаяЕдиница, ОтветственноеЛицо");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		
		ЭтотОбъект[Выборка.ПредставлениеОтветственногоЛица+"Должность"] 	= Выборка.Должность;
		ЭтотОбъект[Выборка.ПредставлениеОтветственногоЛица+"ФизЛицо"] 		= Выборка.ФизическоеЛицо;
		
		ЗаполнитьЗначенияСвойств(Отбор,Выборка);
		
		ЭтотОбъект[Выборка.ПредставлениеОтветственногоЛица + "КлючЗаписи"]	= РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьКлючЗаписи(Отбор);
		
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОтветственныхНаСервере()
	
	Если ИзмененОтветственныйЗаБР Тогда
		ЗаписатьНаборЗаписейИсторииДолжностныхЛиц("ОтветственныйЗаБухгалтерскиеРегистры", Организация,НЕ ЗначениеЗаполнено(ОтветственныйЗаБухгалтерскиеРегистрыКлючЗаписи.период));
		
	КонецЕсли;
	
	Если ИзмененОтветственныйЗаНР Тогда
		ЗаписатьНаборЗаписейИсторииДолжностныхЛиц("ОтветственныйЗаНалоговыеРегистры", Организация,НЕ ЗначениеЗаполнено(ОтветственныйЗаНалоговыеРегистрыКлючЗаписи.период));
		
	КонецЕсли;
	
	Если ИзмененИсполнитель Тогда
		
		ЗаписатьНаборЗаписейИсторииДолжностныхЛиц("Исполнитель", Организация, НЕ ЗначениеЗаполнено(ИсполнительКлючЗаписи.период));
	КонецЕсли;
	
	ЭтотОбъект.Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаборЗаписейИсторииДолжностныхЛиц(роль, Владелец, ЗаписьНового = Ложь) 
	
	История = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьНаборЗаписей();
	История = История.Выгрузить();
	НовСтрока = История.Добавить();
	Если ЗаписьНового тогда
		НовСтрока.СтруктурнаяЕдиница = Владелец;
		НовСтрока.Период = Дата("19800101");
		НовСтрока.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций[роль];
		
	иначе
		ЗаполнитьЗначенияСвойств(НовСтрока,ЭтотОбъект[Роль+"КлючЗаписи"]);
	КонецЕслИ;
	
	Новстрока.ФизическоеЛицо =  ЭтотОбъект[Роль+"ФизЛицо"];
	Новстрока.Должность =  ЭтотОбъект[Роль+"Должность"];
	
	
	
	Набор = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьНаборЗаписей();
	Набор.Отбор.СтруктурнаяЕдиница.Установить(Владелец);
	Набор.Отбор.ОтветственноеЛицо.Установить(Перечисления.ОтветственныеЛицаОрганизаций[роль]);
	Набор.Прочитать();
	ИсторияДоИзменения = Набор.Выгрузить();
	
	// Получим только измененные записи и запишем их поштучно для того, что бы верно сработала дата запрета редактирования
	ИзмененнаяИстория = ИсторияДоИзменения.СкопироватьКолонки();
	ИзмененнаяИстория.Колонки.Добавить("ТипИзменения", Новый ОписаниеТипов("Строка"));
	
	Для Каждого ЗаписьИстории Из История Цикл
		ЗаписьИсторииДоИзменения =  ИсторияДоИзменения.Найти(ЗаписьИстории.Период, "Период");
		Если ЗаписьИсторииДоИзменения = Неопределено Тогда
			ИзмененнаяЗапись = ИзмененнаяИстория.Добавить();
			ИзмененнаяЗапись.ТипИзменения = "Добавление";
			ЗаполнитьЗначенияСвойств(ИзмененнаяЗапись, ЗаписьИстории);
		Иначе
			Для Каждого Колонка Из ИсторияДоИзменения.Колонки Цикл
				Если ЗаписьИстории[Колонка.Имя] <> ЗаписьИсторииДоИзменения[Колонка.Имя] Тогда
					ИзмененнаяЗапись = ИзмененнаяИстория.Добавить();
					ИзмененнаяЗапись.ТипИзменения = "Изменение";
					ЗаполнитьЗначенияСвойств(ИзмененнаяЗапись, ЗаписьИстории);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// Найдем удаленные записи
	Для Каждого ЗаписьИсторииДоИзменения Из ИзмененнаяИстория Цикл
		ЗаписьИстории = ИсторияДоИзменения.Найти(ЗаписьИстории.Период, "Период");
		Если ЗаписьИсторииДоИзменения = Неопределено Тогда
			ИзмененнаяЗапись = ИзмененнаяИстория.Добавить();
			ИзмененнаяЗапись.ТипИзменения = "Удаление";
			ЗаполнитьЗначенияСвойств(ИзмененнаяЗапись, ЗаписьИстории);
		КонецЕсли;
	КонецЦикла;
	
	ИзмененнаяИстория.Сортировать("Период");
	
	Для Каждого ИзмененнаяЗапись ИЗ ИзмененнаяИстория Цикл
		
		НаборЗаписей = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(ИзмененнаяЗапись.Период);
		НаборЗаписей.Отбор.СтруктурнаяЕдиница.Установить(ИзмененнаяЗапись.СтруктурнаяЕдиница);
		НаборЗаписей.Отбор.ОтветственноеЛицо.Установить(ИзмененнаяЗапись.ОтветственноеЛицо);
		
		Если ЗаписьНового Тогда
			НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения", Истина);
		КонецЕсли;
		
		Если ИзмененнаяЗапись.ТипИзменения = "Удаление" Тогда
			НаборЗаписей.Записать();
		Иначе
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, ИзмененнаяЗапись);
			НаборЗаписей.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
