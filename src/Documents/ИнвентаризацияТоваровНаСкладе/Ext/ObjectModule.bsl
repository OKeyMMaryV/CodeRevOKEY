﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-07-26 (#4214) 
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура")
			И ДанныеЗаполнения.Свойство("ДанныеЗаполнения") Тогда
				
		ДанныеЗаполнения = ДанныеЗаполнения.ДанныеЗаполнения;
				
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-07-26 (#4214) 
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-07-26 (#4214) 
	Если ТипДанныхЗаполнения = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("СписокНоменклатуры") Тогда
		
		ЗаполнитьИнвентаризациюСОтборомПоНоменклатуре(ДанныеЗаполнения);
		
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-07-26 (#4214) 
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ОтветственноеЛицо = ОтветственныеЛицаБП.ОтветственноеЛицоНаСкладе(Склад, Дата);
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата 		  = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУчет");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	
	Для каждого Строка Из Товары Цикл
		
		Префикс = "Товары[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru = 'Товары'");
		
		Если Строка.Количество = 0 И Строка.КоличествоУчет = 0 Тогда
			
			ИмяПоля = НСтр("ru = 'Количество'");
			Поле = Префикс + "Количество";
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
			ИмяПоля = НСтр("ru = 'Количество учетное'");
			Поле = Префикс + "КоличествоУчет";
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-07-26 (#4214)
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-07-26 (#4214)
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-07-26 (#4214)
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	ПараметрыПроведения = Документы.ИнвентаризацияТоваровНаСкладе.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПрослеживаемостьБП.ЗарегистрироватьПрослеживаемыйТовар(ПараметрыПроведения.Реквизиты);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	ПрослеживаемостьБП.УдалениеПроведенияПервичногоДокумента(Ссылка);
	
КонецПроцедуры

Процедура ЗаполнитьИнвентаризациюСОтборомПоНоменклатуре(ДанныеЗаполнения)
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	ПараметрыЗаполнения = Новый Структура();
	
	ЭтотОбъект.Дата = ДанныеЗаполнения.Дата;
	
	ПараметрыЗаполнения = Документы.ИнвентаризацияТоваровНаСкладе.НовыеПараметрыЗаполнения();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ДанныеЗаполнения);
	
	Документы.ИнвентаризацияТоваровНаСкладе.ЗаполнитьПоОстаткам(ПараметрыЗаполнения, АдресХранилища);
	
	ДанныеИнвентаризации = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ЭтотОбъект.Товары.Загрузить(ДанныеИнвентаризации.ТаблицаТовары);
	
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-07-26 (#4214) 
#КонецЕсли
