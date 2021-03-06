
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	   	
	фКоличествоРазделителей = 4;  	
	
	ЗаполнитьКэшЗначений(); 	
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОбластиДоступаПриИзменении(Элемент)
	
	ИзменениеВидаОбластиДоступа();	
	
КонецПроцедуры // ВидОбластиДоступаПриИзменении()

&НаКлиенте
Процедура ВидНастройкиПриИзменении(Элемент)
	
	ИзменениеВидаНастройки();	
	 
КонецПроцедуры // ВидНастройкиПриИзменении()

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Запись.ВидНастройки = фКэшЗначений.Перечисления.бит_рлс_ВидыНастроекПрав.Запрет Тогда
		
		МассивТипов = Новый Массив;
  		МассивТипов.Добавить(Тип("СправочникСсылка.Пользователи"));
 		Описание = Новый ОписаниеТипов(МассивТипов);
        Элемент.ОграничениеТипа = Описание;

		Элемент.ВыбиратьТип = Ложь;
		
	Иначе
		
		Если Элемент.ВыбиратьТип = Ложь Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		СписокТипов = Новый СписокЗначений;
		СписокТипов.Добавить(Тип("СправочникСсылка.ГруппыПользователей"));
		СписокТипов.Добавить(Тип("СправочникСсылка.Пользователи"));
				
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("Элемент", Элемент);
												   
		ОписаниеОповещения = Новый ОписаниеОповещения("ПользовательНачалоВыбораЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов);
			
	КонецЕсли;
	
КонецПроцедуры // ПользовательНачалоВыбора()

// Процедура обработчик оповещения "ПользовательНачалоВыбораЗавершение".
// 
// Параметры:
//  ВыбранныйТип - Произвольный
//  ДопПараметры - Структура
// 
&НаКлиенте
Процедура ПользовательНачалоВыбораЗавершение(ВыбранныйТип, ДопПараметры) Экспорт
	  	
	Элемент = ДопПараметры.Элемент;
	
	Если ВыбранныйТип = Неопределено Тогда
		Возврат;
	КонецЕсли;   	
	
	МассивТипов = Новый Массив;
  	МассивТипов.Добавить(ВыбранныйТип.Значение);
 	Описание = Новый ОписаниеТипов(МассивТипов);
    Элемент.ОграничениеТипа = Описание;

	Элемент.ВыбиратьТип = Ложь;
	
КонецПроцедуры // ПользовательНачалоВыбораЗавершение()

&НаКлиенте
Процедура Разделитель_1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РазделительНачалоВыбора(Тип("СправочникСсылка." + фКэшЗначений.ИмяСправочникаЦФО), Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // Разделитель_1НачалоВыбора()

&НаКлиенте
Процедура Разделитель_1Очистка(Элемент, СтандартнаяОбработка)
	
	РазделительОчистка(Тип("СправочникСсылка." + фКэшЗначений.ИмяСправочникаЦФО), Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // Разделитель_1Очистка()

&НаКлиенте
Процедура Разделитель_2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РазделительНачалоВыбора(Тип("СправочникСсылка.бит_СтатьиОборотов"), Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // Разделитель_2НачалоВыбора()

&НаКлиенте
Процедура Разделитель_2Очистка(Элемент, СтандартнаяОбработка)
	
	РазделительОчистка(Тип("СправочникСсылка.бит_СтатьиОборотов"), Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // Разделитель_2Очистка()
     
&НаКлиенте
Процедура Разделитель_3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РазделительНачалоВыбора(Тип("СправочникСсылка.Пользователи"), Элемент, СтандартнаяОбработка);
           	
КонецПроцедуры // Разделитель_3НачалоВыбора()

&НаКлиенте
Процедура Разделитель_3Очистка(Элемент, СтандартнаяОбработка)
	
	РазделительОчистка(Тип("СправочникСсылка.Пользователи"), Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // Разделитель_3Очистка()
        
&НаКлиенте
Процедура Разделитель_4НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РазделительНачалоВыбора(Тип("СправочникСсылка." + фКэшЗначений.ИмяСправочникаПроекты), Элемент, СтандартнаяОбработка);
		
КонецПроцедуры // Разделитель_4НачалоВыбора()

&НаКлиенте
Процедура Разделитель_4Очистка(Элемент, СтандартнаяОбработка)

	РазделительОчистка(Тип("СправочникСсылка." + фКэшЗначений.ИмяСправочникаПроекты), Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // Разделитель_4Очистка()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура производит выбор значения разделителя.
//
// Параметры:
//  ОсновнойТипРеквизита - Тип.
//  Элемент 			 - ПолеФормы.
//  СтандартнаяОбработка - Булево.
//
&НаКлиенте
Процедура РазделительНачалоВыбора(ОсновнойТипРеквизита, Элемент, СтандартнаяОбработка)
	
	ИмяРеквизита = Элемент.Имя; 
	
	Если Запись.ВидНастройки = фКэшЗначений.Перечисления.бит_рлс_ВидыНастроекПрав.Запрет Тогда
				
		МассивТипов = Новый Массив;
	  	МассивТипов.Добавить(ОсновнойТипРеквизита);
	 	Описание = Новый ОписаниеТипов(МассивТипов);
		Элемент.ОграничениеТипа = Описание;

		Элемент.ВыбиратьТип = Ложь;
		
	Иначе
		
		Если ТипЗнч(Запись[ИмяРеквизита]) = Тип("ПеречислениеСсылка.бит_рлс_Все") ИЛИ Запись[ИмяРеквизита] = Неопределено Тогда
			Элемент.ВыбиратьТип = Истина;
		Иначе
			Элемент.ВыбиратьТип = Ложь;
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		СписокТипов = Новый СписокЗначений;
		СписокТипов.Добавить(Тип("ПеречислениеСсылка.бит_рлс_Все"));
		СписокТипов.Добавить(ОсновнойТипРеквизита);
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("Элемент"		, Элемент);
		ДопПараметры.Вставить("ИмяРеквизита", ИмяРеквизита);
												   
		ОписаниеОповещения = Новый ОписаниеОповещения("РазделительНачалоВыбораЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов);  			
			
	КонецЕсли;
		
КонецПроцедуры // РазделительНачалоВыбора()

// Процедура обработчик оповещения "РазделительНачалоВыбораЗавершение".
// 
// Параметры:
//  ВыбранныйТип - Произвольный.
//  ДопПараметры - Структура.
// 
&НаКлиенте
Процедура РазделительНачалоВыбораЗавершение(ВыбранныйТип, ДопПараметры) Экспорт
	
	Элемент 	 = ДопПараметры.Элемент;
	ИмяРеквизита = ДопПараметры.ИмяРеквизита;
	
	Если ВыбранныйТип = Неопределено Тогда
		Возврат;
	КонецЕсли;   	
			
	Если ВыбранныйТип.Значение = Тип("ПеречислениеСсылка.бит_рлс_Все") Тогда
		
		Запись[ИмяРеквизита] = Неопределено;
		Запись[ИмяРеквизита] = фКэшЗначений.ВсеЭлементы;
		
	Иначе
		
		МассивТипов = Новый Массив;
	  	МассивТипов.Добавить(ВыбранныйТип.Значение);
	 	Описание = Новый ОписаниеТипов(МассивТипов);
		Элемент.ОграничениеТипа = Описание;

		Запись[ИмяРеквизита] = Неопределено;
		Запись[ИмяРеквизита] = Элемент.ОграничениеТипа.ПривестиЗначение(Запись[ИмяРеквизита]);
	
		Элемент.ВыбиратьТип = Ложь;
				
	КонецЕсли;     	
	
КонецПроцедуры // РазделительНачалоВыбораЗавершение()

&НаКлиенте
Процедура РазделительОчистка(ОсновнойТипРеквизита, Элемент, СтандартнаяОбработка)

	ИмяРеквизита = Элемент.Имя;
	СтандартнаяОбработка = Ложь;
	
	Если Запись.ВидНастройки = фКэшЗначений.Перечисления.бит_рлс_ВидыНастроекПрав.Запрет Тогда
		
		МассивТипов = Новый Массив;
	
		МассивТипов.Добавить(ОсновнойТипРеквизита);
		Описание = Новый ОписаниеТипов(МассивТипов);
		Элемент.ОграничениеТипа = Описание;
		
		Запись[ИмяРеквизита] = Неопределено;
		Запись[ИмяРеквизита] = Элемент.ОграничениеТипа.ПривестиЗначение(Запись[ИмяРеквизита]);
	
	Иначе
		
		Запись[ИмяРеквизита] = Неопределено;
		Запись[ИмяРеквизита] = фКэшЗначений.ВсеЭлементы;
		
	КонецЕсли;
	
	// Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры // РазделительОчистка()

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	
	// Запишем параметр для формирования заголовка.
	фКэшЗначений.Вставить("ВсеЭлементы", Перечисления.бит_рлс_Все.Все);
	
	фКэшЗначений.Вставить("ИмяСправочникаЦФО"	 , бит_ОбщегоНазначения.ПолучитьИмяСправочникаЦФО());
	фКэшЗначений.Вставить("ИмяСправочникаПроекты", бит_ОбщегоНазначения.ПолучитьИмяСправочникаПроекты());
	
	фКэшЗначений.Вставить("НастройкиВидовОбластей", бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиВидовОбластейДоступа"));
		
	КэшПеречислений = Новый Структура;	
	КэшПеречислений.Вставить("бит_рлс_ВидыНастроекПрав", бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_рлс_ВидыНастроекПрав));
	
	фКэшЗначений.Вставить("Перечисления", КэшПеречислений);
	  	
КонецПроцедуры // ЗаполнитьКэшЗначений()
   
// Процедура устанавливает видимость, доступность... элементов формы.
// 
&НаСервере
Процедура УстановитьВидимостьДоступностьПоВидуОбластейДоступа()

	ВидыОбластей = Перечисления.бит_рлс_ВидыОбластейДоступа;
	
	Элементы.ГруппаЦФОСтатьяОборотов.Видимость = Запись.ВидОбластиДоступа = ВидыОбластей.ЦФОСтатьиОборотов;
	Элементы.Разделитель_3.Видимость 		   = Запись.ВидОбластиДоступа = ВидыОбластей.Пользователи;
	Если Метаданные.РегистрыСведений.бит_рлс_ПраваДоступа.Измерения.Найти("Разделитель_4") <> Неопределено Тогда
		Элементы.Разделитель_4.Видимость = Запись.ВидОбластиДоступа = ВидыОбластей.Проекты;	
	КонецЕсли;

КонецПроцедуры // УстановитьВидимостьДоступностьПоВидуОбластейДоступа()

// Процедура устанавливает видимость, доступность... элементов формы.
// 
&НаСервере
Процедура УстановитьВидимостьДоступностьПоВидуНстройки()

	Элементы.Чтение.ТолькоПросмотр = Запись.ВидНастройки = Перечисления.бит_рлс_ВидыНастроекПрав.Доступ;
	Элементы.Запись.ТолькоПросмотр = Запись.ВидНастройки = Перечисления.бит_рлс_ВидыНастроекПрав.Запрет;

КонецПроцедуры // УстановитьВидимостьДоступностьПоВидуНстройки()

// Процедура устанавливает видимость, доступность... элементов формы.
// 
&НаСервере
Процедура УстановитьВидимостьДоступность()

	УстановитьВидимостьДоступностьПоВидуОбластейДоступа();
	УстановитьВидимостьДоступностьПоВидуНстройки();

	// Изменение кода. Начало. 26.12.2016{{
	Элементы.ГруппаЗамещение.Видимость = Запись.Замещение;
	// Изменение кода. Конец. 26.12.2016}}
	
КонецПроцедуры // УстановитьВидимостьДоступность()


// Процедура устанавливает значения разделителей по виду области.
// 
&НаСервере
Процедура УстановитьЗначенияРазделителей()

	Разделители = фКэшЗначений.НастройкиВидовОбластей[Запись.ВидОбластиДоступа];
	ЭтоДоступ = Запись.ВидНастройки = Перечисления.бит_рлс_ВидыНастроекПрав.Доступ;
	
	Если Разделители <> Неопределено Тогда
		
		Для каждого КлЗнч Из Разделители Цикл
		
			ИмяРазделителя = КлЗнч.Ключ;
			Настройка      = КлЗнч.Значение;

			Если Настройка = Неопределено Тогда
			 
				Запись[ИмяРазделителя] = Неопределено;
			 
			Иначе	
				
				Если ЭтоДоступ И Запись[ИмяРазделителя] = Неопределено Тогда
					
					МассивТипов = Новый Массив;
				  	МассивТипов.Добавить(Тип("ПеречислениеСсылка.бит_рлс_Все"));
				 	Описание = Новый ОписаниеТипов(МассивТипов);
					Элементы[ИмяРазделителя].ОграничениеТипа = Описание;
					
					Запись[ИмяРазделителя] = фКэшЗначений.ВсеЭлементы;
					
				Иначе				
					
					Описание = Новый ОписаниеТипов(Настройка.Типы);
					
					Запись[ИмяРазделителя] = Описание.ПривестиЗначение(Запись[ИмяРазделителя]);
					
				КонецЕсли;
			
			КонецЕсли;	
		
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры // УстановитьЗначенияРазделителей()

// Процедура обрабатывает действия, необходимые при изменении вида области доступа.
// 
&НаСервере
Процедура ИзменениеВидаОбластиДоступа()

	УстановитьЗначенияРазделителей();
		 	
	УстановитьВидимостьДоступность();	

КонецПроцедуры // ИзменениеВидаОбластиДоступа()

// Процедура обрабатывает действия, необходимые при изменении вида настройки.
// 
&НаСервере
Процедура ИзменениеВидаНастройки()

	Если Запись.ВидНастройки = Перечисления.бит_рлс_ВидыНастроекПрав.Доступ Тогда
	
		Запись.Чтение = Истина;
		
	ИначеЕсли Запись.ВидНастройки = Перечисления.бит_рлс_ВидыНастроекПрав.Запрет Тогда
		
		Запись.Запись = Истина;
		
		// Запрет настраивается на конкретных пользователей и на конкретные значения ссылок.
		ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
		Запись.Пользователь = ОписаниеТипов.ПривестиЗначение(Запись.Пользователь);
		
		УстановитьЗначенияРазделителей();
				
	КонецЕсли;
	
	УстановитьВидимостьДоступностьПоВидуНстройки();

КонецПроцедуры // ИзменениеВидаНастройки()

#КонецОбласти
