
#Область ОписаниеПеременных

&НаКлиенте
Перем мТекущийТипОбъекта; // Хранит текущий тип объекта

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	фЭтоТолстыйКлиент = Ложь;


    #Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда	 
  	фЭтоТолстыйКлиент = Истина;	 
    #КонецЕсли  
	
	Если фЭтоТолстыйКлиент Тогда
		
		ТипОбъекта = ТекущийОбъект.ПолучитьТипЗначенияОбъекта();
		
	КонецЕсли; 
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	
	
	// Вызов механизма защиты
		
	Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	фЭтоТолстыйКлиент = Ложь;
    #Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда	 
  	фЭтоТолстыйКлиент = Истина;	 
    #КонецЕсли  
    Элементы.ТипОбъекта.Видимость = фЭтоТолстыйКлиент;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	мТекущийТипОбъекта = ТипОбъекта;
	
КонецПроцедуры // ПриОткрытии()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если фЭтоТолстыйКлиент Тогда
		
		ТекущийОбъект.СохранитьТип(ТипОбъекта);
		
	КонецЕсли; 
	
КонецПроцедуры // ПередЗаписьюНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	Отказ = Ложь;
	ИзменениеТипаОбъекта(Отказ);

	Если Отказ Тогда

		ТипОбъекта = мТекущийТипОбъекта;
		Возврат;

	КонецЕсли; 

	мТекущийТипОбъекта = ТипОбъекта;	 
	 
КонецПроцедуры // ТипОбъектаПриИзменении()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обрабатывает изменение типа объекта. 
// 
&НаСервере
Процедура ИзменениеТипаОбъекта(Отказ)

	 МассивТипов = ТипОбъекта.Типы();
	
	 Если МассивТипов.Количество() = 1 Тогда
		 
	 	  МетаОбъект = Метаданные.НайтиПоТипу(МассивТипов[0]);
		  
		  Если НЕ МетаОбъект = Неопределено Тогда
		  
			Объект.Наименование     = МетаОбъект.Синоним;
			Объект.ИмяОбъекта       = МетаОбъект.Имя;
		  	Объект.ИмяОбъектаПолное = МетаОбъект.ПолноеИмя();
			Объект.ВидОбъекта       = бит_УправлениеОбъектамиСистемы.ПолучитьВидОбъектаПоМетаданным(МетаОбъект);
			
		  Иначе	
			  
			  Отказ = Истина;
			  
			  ТекстСообщения =  НСтр("ru = 'Не удалось найти объект метаданных, соответствующий выбранному типу.'");
			  бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			  
		  КонецЕсли; 
		  
	  Иначе
		  
		 // Выбор хотя бы одного типа контролируется платформой в системном диалоге выбора типа,
		 // следовательно, данная ветка соответствует выбору составного типа.
		 ТекстСообщения =  НСтр("ru = 'Выбор составного типа недопустим!'");
		 бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		 
		 Отказ = Истина;
		  
	 КонецЕсли; 

	 УправлениеЭлементамиФормы();
	 
 КонецПроцедуры // ИзменениеТипаОбъекта()
 
 // Процедура управляет видимостью/доступностью элементов формы. 
 //
 &НаСервере
 Процедура УправлениеЭлементамиФормы()
	 
	 ЭтоОбъектБИТ = ?(ВРег(Лев(Объект.ИмяОбъекта,4)) = ВРЕГ("бит_"), Истина, Ложь);
	 
	 ЭтоРБ  = ?(Объект.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии, Истина, Ложь);
	 ЭтоПС  = ?(Объект.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов, Истина, Ложь);
	 ЭтоПВХ = ?(Объект.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланВидовХарактеристик, Истина, Ложь);
	 
	 Элементы.ГруппаЗаголовки.Видимость = ЭтоОбъектБИТ И (ЭтоПВХ ИЛИ ЭтоПС ИЛИ ЭтоРБ);
	 Элементы.ЗаголовокЭлемента.Видимость = ЭтоОбъектБИТ И (ЭтоПВХ ИЛИ ЭтоПС);
	 
 КонецПроцедуры // УправлениеЭлементамиФормы()
 
#КонецОбласти

