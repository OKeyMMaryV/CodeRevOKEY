﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_НазначенныеЗаместители;
		
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	ОбластьЗамещения = ?(ЗначениеЗаполнено(Запись.РольИсполнителя), 1, 0);
	
	МаксКоличествоОбъектов = бит_уп_Сервер.МаксимальноеКоличествоОбъектовАдресации();
	НастройкиАдресации = Справочники.бит_РолиИсполнителей.НастройкиОбъектовАдресации(Запись.РольИсполнителя);
	
	УстановитьВидимость();
	
	//+СБ Пискунова 02.03.2017 #2691 
	//Добавим реквизиты на формы
	ЕстьПолныеПрава = РольДоступна("ПолныеПрава");
	СБ_РаботаСФормамиОбъекты.бит_НазначенныеЗаместителиФормаЗаписиПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка,ЕстьПолныеПрава);
	//-СБ Пискунова 02.03.2017 #2691
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-08-25 (#2875)
	Если УправлениеДоступом.ЕстьРоль("ПолныеПрава"		,,Пользователи.ТекущийПользователь()) ИЛИ
		 УправлениеДоступом.ЕстьРоль("бит_БК_ГлавныйБК" ,,Пользователи.ТекущийПользователь())
	Тогда 
		Элементы.Пользователь.ТолькоПросмотр = Ложь;
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-08-25 (#2875)
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбластьЗамещения = 1 Тогда
		
		ПроверяемыеРеквизиты.Добавить("РольИсполнителя");
		
	Иначе	
		
		ПроверяемыеРеквизиты.Добавить("Виза");
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбластьЗамещенияПриИзменении(Элемент)
	
	ОбластьЗамещенияИзменение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВизаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить(Тип("СправочникСсылка.бит_Визы"), "Визы");
	СписокТипов.Добавить(Тип("СправочникСсылка.бит_ГруппыВиз"), "Группы виз");	
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,Запись
	                                                   ,"Виза"
													   ,СписокТипов
													   ,СтандартнаяОбработка);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВизаОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РольИсполнителяПриИзменении(Элемент)
	
	РольИсполнителяИзменение();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектАдресации_1Очистка(Элемент, СтандартнаяОбработка)
	
	ОчисткаОбъектаАдресации("ОбъектАдресации_1");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектАдресации_2Очистка(Элемент, СтандартнаяОбработка)
	
	ОчисткаОбъектаАдресации("ОбъектАдресации_2");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектАдресации_3Очистка(Элемент, СтандартнаяОбработка)
	
	ОчисткаОбъектаАдресации("ОбъектАдресации_3");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура управляет видимостью/доступностью элементов формы.
// 
&НаСервере
Процедура УстановитьВидимость()

   ЭтоВизы = ОбластьЗамещения = 0;	
   
   Элементы.Виза.Видимость = ЭтоВизы;
   Элементы.ПользовательскоеУсловие.Видимость = ЭтоВизы;
   Элементы.РольИсполнителя.Видимость = НЕ ЭтоВизы;
   
	НачалоИмени = "ОбъектАдресации_";
	Для  н = 1 по МаксКоличествоОбъектов Цикл
		
		Имя          = НачалоИмени + н;
		ТекНастройка = Неопределено;
		НастройкиАдресации.Свойство(Имя, ТекНастройка);
		
		флВидимость    = Ложь;
		флОбязательный = Ложь;
		ТекЗаголовок   = НСтр("ru = 'Объект адресации №'") + н;
		Если ТекНастройка <> Неопределено Тогда
			
			флВидимость    = Истина;
			ТекЗаголовок   = ТекНастройка.Синоним;
			флОбязательный = ТекНастройка.Обязательный;
			
		КонецЕсли; 
		
		Элементы[Имя].Видимость = флВидимость;
		Элементы[Имя].Заголовок = ТекЗаголовок;
		Элементы[Имя].АвтоОтметкаНезаполненного = флОбязательный;
		
	КонецЦикла; 
   
КонецПроцедуры // УстановитьВидимость()

// Процедура обрабатывает изменение области замещения.
// 
&НаСервере
Процедура ОбластьЗамещенияИзменение()
	
	УстановитьВидимость();	
	
	Если ОбластьЗамещения = 1 Тогда
	
		Запись.Виза = Неопределено;
		
	Иначе
		
		Запись.РольИсполнителя = Неопределено;
        
        Для н = 1 По МаксКоличествоОбъектов Цикл		
			Запись["ОбъектАдресации_" + н] = Неопределено;		
		КонецЦикла; 
	
	КонецЕсли; 
	
КонецПроцедуры // ОбластьЗамещенияИзменение()

// Процедура обрабатывает изменение роли исполнителя. 
// 
&НаСервере
Процедура РольИсполнителяИзменение()
	
	НастройкиАдресации = Справочники.бит_РолиИсполнителей.НастройкиОбъектовАдресации(Запись.РольИсполнителя);
	
	// Присвоим типы объектам адресации
	НачалоИмени = "ОбъектАдресации_";
	Для  н = 1 по МаксКоличествоОбъектов Цикл
		
		Имя          = НачалоИмени + н;
		ТекНастройка = Неопределено;
		НастройкиАдресации.Свойство(Имя, ТекНастройка);
		
		Если ТекНастройка <> Неопределено Тогда
			
			Запись[Имя] = ТекНастройка.Тип.ПривестиЗначение(Запись[Имя]);
			
		Иначе
			
			Запись[Имя] = Неопределено;
			
		КонецЕсли; 
		
	КонецЦикла; // МаксКоличествоОбъектов
	
	
	УстановитьВидимость();	
	
КонецПроцедуры // РольИсполнителяИзменение()

// Процедура осуществляет очистку объекта адресации. 
// 
// Параметры:
//  Имя - Строка.
// 
&НаКлиенте
Процедура ОчисткаОбъектаАдресации(Имя)
	
	ТекНастройка = Неопределено;
	НастройкиАдресации.Свойство(Имя, ТекНастройка);
	
	Если ТекНастройка <> Неопределено Тогда
		
		Запись[Имя] = ТекНастройка.Тип.ПривестиЗначение(Запись[Имя]);
		
	Иначе
		
		Запись[Имя] = Неопределено;
		
	КонецЕсли; 
	
КонецПроцедуры // ОчисткаОбъектаАдресации()

#КонецОбласти
