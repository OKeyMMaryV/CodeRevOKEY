﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
// 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	МаксКоличествоОбъектов = бит_уп_Сервер.МаксимальноеКоличествоОбъектовАдресации();
	НастройкиАдресации = Справочники.бит_РолиИсполнителей.НастройкиОбъектовАдресации(Запись.РольИсполнителя);
	
	УстановитьВидимость();
	
	// Заместителя не копируем
	флЭтоЗам = ЗначениеЗаполнено(Запись.Замещаемый);
	Если НЕ Параметры.ЗначениеКопирования.Пустой() Тогда
	
		Запись.Замещаемый = Справочники.Пользователи.ПустаяСсылка();
	
	КонецЕсли; 
	
	Элементы.ГруппаЗамещение.Видимость = флЭтоЗам;
	Если флЭтоЗам Тогда
	
		ЭтаФорма.ТолькоПросмотр = Истина;
		
		ПарамЗаместителя = РегистрыСведений.бит_НазначенныеЗаместители.КонструкторПараметрыНазначенияЗаместителя();
		ЗаполнитьЗначенияСвойств(ПарамЗаместителя, Запись);
		ПарамЗаместителя.Заместитель  = Запись.Исполнитель;
		ПарамЗаместителя.Пользователь = Запись.Замещаемый;
		Элементы.ДекорацияИнфоПериодЗамещения.Заголовок = РегистрыСведений.бит_НазначенныеЗаместители.ПредставлениеПериодаЗамещения(ПарамЗаместителя);
	
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события "ПередЗаписьюНаСервере" формы.
// 
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для каждого КиЗ Из НастройкиАдресации Цикл
		
		ТекНастройка = КиЗ.Значение;
		Имя = КиЗ.Ключ;
		
		Если ТекНастройка.Обязательный 
			И НЕ ЗначениеЗаполнено(Запись[Имя]) Тогда
			
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Не указан обязательный объект адресации ""%1%""!'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекНастройка.Синоним);
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриИзменении" поля ввода "РольИсполнителя".
// 
&НаКлиенте
Процедура РольИсполнителяПриИзменении(Элемент)
	
	РольИсполнителяИзменение();
	
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода "ОбъектАдресации_1".
// 
&НаКлиенте
Процедура ОбъектАдресации_1Очистка(Элемент, СтандартнаяОбработка)
	
	ОчисткаОбъектаАдресации("ОбъектАдресации_1");
	
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода "ОбъектАдресации_2".
// 
&НаКлиенте
Процедура ОбъектАдресации_2Очистка(Элемент, СтандартнаяОбработка)
	
	ОчисткаОбъектаАдресации("ОбъектАдресации_2");
	
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода "ОбъектАдресации_3".
// 
&НаКлиенте
Процедура ОбъектАдресации_3Очистка(Элемент, СтандартнаяОбработка)
	
	ОчисткаОбъектаАдресации("ОбъектАдресации_3");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура осуществляет очистку объекта адресации. 
// 
// Параметры:
//  Имя - Строка.
// 
&НаКлиенте
Процедура ОчисткаОбъектаАдресации(Имя)
	
	ТекНастройка = Неопределено;
	НастройкиАдресации.Свойство(Имя, ТекНастройка);
	
	Если НЕ ТекНастройка = Неопределено Тогда
		
		Запись[Имя] = ТекНастройка.Тип.ПривестиЗначение(Запись[Имя]);
		
	Иначе
		
		Запись[Имя] = Неопределено;
		
	КонецЕсли; 
	
КонецПроцедуры // ОчисткаОбъектаАдресации()

// Процедура управляет видимостью/доступностью элементов формы. 
// 
&НаСервере
Процедура УстановитьВидимость()
	
	НачалоИмени = "ОбъектАдресации_";
	Для  н = 1 по МаксКоличествоОбъектов Цикл
		
		Имя          = НачалоИмени+н;
		ТекНастройка = Неопределено;
		НастройкиАдресации.Свойство(Имя, ТекНастройка);
		
		флВидимость    = Ложь;
		флОбязательный = Ложь;
		ТекЗаголовок   = НСтр("ru = 'Объект адресации №'")+н;
		Если НЕ ТекНастройка = Неопределено Тогда
			
			флВидимость    = Истина;
			ТекЗаголовок   = ТекНастройка.Синоним;
			флОбязательный = ТекНастройка.Обязательный;
			
		КонецЕсли; 
		
		Элементы[Имя].Видимость = флВидимость;
		Элементы[Имя].Заголовок = ТекЗаголовок;
		Элементы[Имя].АвтоОтметкаНезаполненного = флОбязательный;
		
	КонецЦикла; 
	
КонецПроцедуры // УстановитьВидимость()

// Процедура обрабатывает изменение роли исполнителя. 
// 
&НаСервере
Процедура РольИсполнителяИзменение()
	
	НастройкиАдресации = Справочники.бит_РолиИсполнителей.НастройкиОбъектовАдресации(Запись.РольИсполнителя);
	
	// Присвоим типы объектам адресации
	НачалоИмени = "ОбъектАдресации_";
	Для  н = 1 по МаксКоличествоОбъектов Цикл
		
		Имя          = НачалоИмени+н;
		ТекНастройка = Неопределено;
		НастройкиАдресации.Свойство(Имя, ТекНастройка);
		
		Если НЕ ТекНастройка = Неопределено Тогда
			
			Запись[Имя] = ТекНастройка.Тип.ПривестиЗначение(Запись[Имя]);
			
		Иначе
			
			Запись[Имя] = Неопределено;
			
		КонецЕсли; 
		
	КонецЦикла; // МаксКоличествоОбъектов
	
	
	УстановитьВидимость();	
	
КонецПроцедуры // РольИсполнителяИзменение()

#КонецОбласти

