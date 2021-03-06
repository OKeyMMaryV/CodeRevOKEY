#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область СлужебныйПрограммныйИнтерфейс
 
// Процедура устанавливает маски кода для планов счетов БИТ по умолчанию.
// 
// Параметры:
//  Нет
// 
Процедура УстановитьМаскиКодаПлановСчетовПоУмолчанию() Экспорт

	НаборЗаписей = РегистрыСведений.бит_МаскиКодов.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
		Возврат;	
	КонецЕсли;
	
	ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов; 
	
	МетаКоллекция = Метаданные.ПланыСчетов;
	Маска  		  = "@@@@@@";
	
	Для каждого МетаПланСчетов Из МетаКоллекция Цикл
		
		Если Найти(МетаПланСчетов.Имя, "бит_") = 0 Тогда
			Продолжить;
		КонецЕсли;
			
		ТипОбъекта = Тип("ПланСчетовСсылка." + МетаПланСчетов.Имя);
		ТекОбъект  = бит_УправлениеОбъектамиСистемы.НайтиОбъектДоступаПоТипу(ТипОбъекта, ВидОбъекта);
		
		Если ЗначениеЗаполнено(ТекОбъект) Тогда			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.ОбъектСистемы = ТекОбъект;
			НоваяЗапись.ИмяРеквизита  = "Код";
			НоваяЗапись.МаскаКода  	  = Маска;
			НоваяЗапись.МаскаТекущая  = Маска;
		КонецЕсли; 		                                      					
	
	КонецЦикла;
	
	НаборЗаписей.Записать();

КонецПроцедуры // УстановитьМаскиКодаПлановСчетовПоУмолчанию()

// Процедура конвертирует маски кода для планов счетов БИТ.
// 
// Параметры:
//  Нет
// 
Процедура КонвертироватьМаскиКодаПлановСчетов() Экспорт

	НаборЗаписей = РегистрыСведений.бит_МаскиКодов.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
		
	ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов;
	Для каждого Запись Из НаборЗаписей Цикл
		Если ТипЗнч(Запись.ОбъектСистемы) = Тип("СправочникСсылка.бит_ОбъектыСистемы") Тогда
			Продолжить;
		КонецЕсли;	
		ТипОбъекта = Тип("ПланСчетовСсылка." + Запись.ОбъектСистемы);
		ТекОбъект  = бит_УправлениеОбъектамиСистемы.НайтиОбъектДоступаПоТипу(ТипОбъекта, ВидОбъекта);
		Если ЗначениеЗаполнено(ТекОбъект) Тогда
			Запись.ОбъектСистемы = ТекОбъект;
			Запись.ИмяРеквизита  = "Код";
		КонецЕсли;
    КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);

КонецПроцедуры // КонвертироватьМаскиКодаПлановСчетов()

// Процедура конвертирует коды.
// 
// Параметры:
//  МассивВыделенных - Массив
// 
Функция КонвертироватьКоды(МассивВыделенных) Экспорт
	
	МассивИзмененных = Новый Массив;
	
	КоличествоСтрокДляИзменения = 0;
			
	// Текст запроса
	ТекстЗапроса = "";
	
	Для каждого РсКлючЗаписи Из МассивВыделенных Цикл
		
		ОбъектСистемы    = РсКлючЗаписи.ОбъектСистемы;
		ИмяРеквизита     = РсКлючЗаписи.ИмяРеквизита;
		ИмяОбъекта 	     = ОбъектСистемы.ИмяОбъекта;
		ИмяОбъектаПолное = ОбъектСистемы.ИмяОбъектаПолное;
		ВидОбъекта	     = ОбъектСистемы.ВидОбъекта;
		
		МенеджерЗаписи = РегистрыСведений.бит_МаскиКодов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбъектСистемы = ОбъектСистемы;
		МенеджерЗаписи.ИмяРеквизита  = ИмяРеквизита;
		МенеджерЗаписи.Прочитать();
		
		МаскаКода    = МенеджерЗаписи.МаскаКода;
		МаскаТекущая = МенеджерЗаписи.МаскаТекущая;
		
		// Если ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов Тогда
		// 	СтрокаПорядка = ТаблОбъекта + ".Порядок";
		// Иначе	
		// 	СтрокаПорядка = "Null";
		// КонецЕсли;
		
		Если МаскаКода <> МаскаТекущая Тогда
						
			КоличествоСтрокДляИзменения = КоличествоСтрокДляИзменения + 1;
			
			Если КоличествоСтрокДляИзменения > 1 Тогда
				
				ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
			    |";
				
			КонецЕсли;
			
				ТаблОбъекта = "ТаблОбъекта_" + Строка(КоличествоСтрокДляИзменения);
				
				ТекстЗапроса = ТекстЗапроса + "
				|ВЫБРАТЬ
				|	""" + ИмяОбъекта + ИмяРеквизита + """ КАК ИмяОбъекта_ИмяРеквизита,
                |   %ЭтоСправочник%                       КАК ЭтоСправочник,
				|	""" + ИмяОбъектаПолное    		+ """ КАК ИмяОбъектаПолное,
				|	""" + ИмяОбъекта    + """ КАК ИмяОбъекта,
				|	""" + ИмяРеквизита  + """ КАК ИмяРеквизита,
				|	""" + МаскаКода     + """ КАК МаскаКода,
				|	""" + МаскаТекущая  + """ КАК МаскаТекущая,
				|	" + ТаблОбъекта + ".Ссылка,
                |   %ЭтоГруппа% КАК ЭтоГруппа,                
				|	" + ТаблОбъекта + "." + ИмяРеквизита + " КАК ЗначениеРеквизита
				|ИЗ
				|	" + ИмяОбъектаПолное + " КАК " + ТаблОбъекта + " 
				|
				|";
                
                ЭтоСправочник = Найти(ИмяОбъектаПолное, "Справочник") <> 0;
                Если ЭтоСправочник Тогда
                    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЭтоСправочник%", "Истина");
                    Если бит_РаботаСМетаданными.ЭтоИерархияЭлементов(Метаданные.Справочники[ИмяОбъекта]) Тогда
                        ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЭтоГруппа%", "Ложь");
                    Иначе	
                        ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЭтоГруппа%", ТаблОбъекта + ".Ссылка.ЭтоГруппа");
                    КонецЕсли;
                Иначе
                    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЭтоСправочник%", "Ложь");
                    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЭтоГруппа%", "Ложь");
                КонецЕсли;
            
		КонецЕсли;
		
	КонецЦикла;
	
	// Если есть строки для изменения
	Если КоличествоСтрокДляИзменения > 0 Тогда
		   		
		ТекстЗапроса = ТекстЗапроса + "
		|ИТОГИ
		|	МАКСИМУМ(МаскаКода) , МАКСИМУМ(ЭтоСправочник),
		|	МАКСИМУМ(ИмяОбъектаПолное), 
		|	МАКСИМУМ(ИмяОбъекта), МАКСИМУМ(ИмяРеквизита) 
		|ПО
		|	ИмяОбъекта_ИмяРеквизита
		|
		|";
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		
		Результат = Запрос.Выполнить();
								
		// Обработка результата запроса
		ВыборкаВерх = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Пока ВыборкаВерх.Следующий() Цикл
			
			ИмяОбъектаПолное = ВыборкаВерх.ИмяОбъектаПолное;
			ИмяОбъекта 	 	 = ВыборкаВерх.ИмяОбъекта;
			ИмяРеквизита 	 = ВыборкаВерх.ИмяРеквизита;
			МаскаКода 	 	 = ВыборкаВерх.МаскаКода; 
			МаскаТекущая 	 = ВыборкаВерх.МаскаТекущая;
            
            ЭтоСправочник = ВыборкаВерх.ЭтоСправочник;
            Если ЭтоСправочник Тогда
                ИспРек = Метаданные.Справочники[ИмяОбъекта].Реквизиты[ИмяРеквизита].Использование;
                ИспользованиеРекТолькоЭлементы = ИспРек = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента;
                ИспользованиеРекТолькоГруппы   = ИспРек = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппы;
            КонецЕсли;            
			
			// Массив имен измененных объектов.
			СтрокаТипа = СтрЗаменить(ИмяОбъектаПолное, ".", "Ссылка.");
			МассивИзмененных.Добавить(СтрокаТипа);
			
			// Анализ маски кода.
			ДлинаМаски 				= СтрДлина(МаскаКода);
			КоличествоРазделителей  = бит_БухгалтерияКлиентСервер.ПолучитьКоличествоРазделителейМаски(МаскаКода);
			МаскаКоличествоЗначимых = ДлинаМаски - КоличествоРазделителей;
                            				
			Выборка = ВыборкаВерх.Выбрать();
			Пока Выборка.Следующий() Цикл
		
				ТекущийОбъект = Выборка.Ссылка.ПолучитьОбъект();
                
                Если ЭтоСправочник Тогда
                    Если (ИспользованиеРекТолькоЭлементы И Выборка.ЭтоГруппа)
                        ИЛИ (ИспользованиеРекТолькоГруппы И НЕ Выборка.ЭтоГруппа) Тогда                    
                    	Продолжить;                    
                    КонецЕсли;
                КонецЕсли;
            
				ТекущийКод = Выборка.ЗначениеРеквизита;
				ЧистыйКод  = бит_БухгалтерияКлиентСервер.УдалитьРазделителиИзСтроки(ТекущийКод);
				ЧистыйКод  = СокрЛП(СтрЗаменить(ЧистыйКод, " ", ""));
				
				ДлинаЧистого 			= СтрДлина(ЧистыйКод);
				ДлинаЧистогоБезПробелов = СтрДлина(СтрЗаменить(ЧистыйКод, " ", ""));
				НовыйКод  = "";
				НомерЗнч  = 1;
				
				Если ДлинаЧистого > МаскаКоличествоЗначимых Тогда
					ТекстСообщения = "Не удалось записать реквизит """ + ИмяРеквизита + "(" + ТекущийКод + ")"
								 + """ для объекта """ + ИмяОбъектаПолное + """(" + Выборка.Ссылка + ").";
					бит_ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения,,, СтатусСообщения.Информация); 				
					Продолжить;			
				КонецЕсли;
				
				Для Ст = 1 По ДлинаМаски Цикл
					
					ТекСимволМаски = Сред(МаскаКода, Ст, 1);
					Если ТекСимволМаски = "@" Тогда
						ТекущийСимвол = Сред(ЧистыйКод, НомерЗнч, 1); 
						НовыйКод = НовыйКод + ТекущийСимвол;
						НомерЗнч = НомерЗнч + 1;
					Иначе
						Если ДлинаЧистогоБезПробелов >= НомерЗнч Тогда 
							НовыйКод = НовыйКод + ТекСимволМаски;
						КонецЕсли; 							
					КонецЕсли;
								
				КонецЦикла;
				
				ТекущийОбъект[ИмяРеквизита] = СокрЛп(НовыйКод);
				
				// Запись объекта
				Если Лев(ИмяОбъектаПолное, 10) = "ПланСчетов" Тогда
					
					ТекущийОбъект.Порядок = РегистрыСведений.бит_МаскиКодов.ПолучитьПорядокКодаПоМаскеКода(МаскаКода, НовыйКод);
					
					Если Не ТекущийОбъект.Предопределенный Тогда 						
						Для каждого Суб Из ТекущийОбъект.ВидыСубконто Цикл
							Если Суб.Предопределенное Тогда
						    	Суб.Предопределенное = Ложь;						
							КонецЕсли;					
						КонецЦикла;
					КонецЕсли;	
					
					ОбъектЗаписан = бит_ОбщегоНазначения.ЗаписатьСчет(ТекущийОбъект
							, Метаданные.ПланыСчетов[ИмяОбъекта].Синоним, , "Ошибки", Истина);   							   	
					
				ИначеЕсли Лев(ИмяОбъектаПолное, 10) = "Справочник" Тогда
					
					ОбъектЗаписан = бит_ОбщегоНазначения.ЗаписатьСправочник(ТекущийОбъект, , "Ошибки", Истина);
					
				КонецЕсли;
			
			КонецЦикла;
			
			// Изменить регистр сведений
			МенеджерЗаписи = РегистрыСведений.бит_МаскиКодов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОбъектСистемы = ОбъектСистемы;
			МенеджерЗаписи.ИмяРеквизита  = ИмяРеквизита;
			МенеджерЗаписи.Прочитать();
			ФлагАвтозаполнения = МенеджерЗаписи.Автозаполнение;
			МенеджерЗаписи.Удалить();
			
			МенеджерЗаписи = РегистрыСведений.бит_МаскиКодов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОбъектСистемы  = ОбъектСистемы;
			МенеджерЗаписи.ИмяРеквизита   = ИмяРеквизита;
			МенеджерЗаписи.МаскаКода      = МаскаКода;
			МенеджерЗаписи.МаскаТекущая   = МаскаКода;
			МенеджерЗаписи.Автозаполнение = ФлагАвтозаполнения;
			МенеджерЗаписи.Записать();

		КонецЦикла;
				
	КонецЕсли;
	
	Возврат МассивИзмененных;
	
КонецФункции		
		
// Процедура получает текущую маску реквизита.
// 
// Параметры:
//  ТекОбъектСистемы 	 - СправочникСсылка.бит_ОбъектыСистемы
//  ТекИмяРеквизита 	     - Строка
//  ЗаполнятьПоУмолчанию - Булево (По умолчанию = Ложь).
// 
Функция ПолучитьМаскуРеквизита(ТекОбъектСистемы, ТекИмяРеквизита, ЗаполнятьПоУмолчанию = Ложь) Экспорт

	МенеджерЗаписи = РегистрыСведений.бит_МаскиКодов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОбъектСистемы = ТекОбъектСистемы;
	МенеджерЗаписи.ИмяРеквизита  = ТекИмяРеквизита;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда 		
		МаскаТекущая     	 = МенеджерЗаписи.МаскаТекущая;
		ЗаполнятьПоУмолчанию = МенеджерЗаписи.Автозаполнение;
	Иначе
		// ТекстСообщения = Нстр("ru = 'Не найдена маска.'");
		// бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);  		
		Если ТекОбъектСистемы.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов Тогда
			МетаПлана    = Метаданные.ПланыСчетов[ТекОбъектСистемы.ИмяОбъекта];
			МаскаТекущая = МетаПлана.МаскаКода
		Иначе
			МаскаТекущая = "";	
		КонецЕсли;
	КонецЕсли;                                     	
	
	Возврат МаскаТекущая;

КонецФункции // ПолучитьМаскуРеквизита()

// Процедура получает текущую маску кода плана счетов.
// 
// Параметры:
//  ИмяПланаСчетов - Строка
// 
Функция ПолучитьМаскуКодаПланаСчетов(ИмяПланаСчетов) Экспорт

	ТипОбъекта = Тип("ПланСчетовСсылка." + ИмяПланаСчетов);
	ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов;
	
	ТекОбъектСистемы = бит_УправлениеОбъектамиСистемы.НайтиОбъектДоступаПоТипу(ТипОбъекта, ВидОбъекта);
	Если ЗначениеЗаполнено(ТекОбъектСистемы) Тогда
		МаскаТекущая = ПолучитьМаскуРеквизита(ТекОбъектСистемы, "Код");	
	Иначе	
	    МаскаТекущая = "";
	КонецЕсли;         	
	
	Возврат МаскаТекущая;

КонецФункции // ПолучитьМаскуКодаПланаСчетов()
      
// Функция получает маску кода по умолчанию.
// 
// Параметры:
//  ОбъектСистемы - СправочникСсылка.бит_ОбъектыСистемы
//  ИмяРеквизита  - Строка.
// 
Функция ПолучитьМаскуКодаПоУмолчанию(ОбъектСистемы, ИмяРеквизита) Экспорт

	ТекМаска = "";
	
	Если ЗначениеЗаполнено(ОбъектСистемы) И ЗначениеЗаполнено(ИмяРеквизита) Тогда
			
		ТекВидОбъекта   = ОбъектСистемы.ВидОбъекта;
		ТекИмяОбъекта   = ОбъектСистемы.ИмяОбъекта;
		ТекИмяРеквизита = ИмяРеквизита;
		
		Если ТекВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов Тогда
			
			ТекМаска = Метаданные.ПланыСчетов[ТекИмяОбъекта].МаскаКода;
			
		ИначеЕсли ТекВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Справочник Тогда
			
			НайденныйРеквизит = Метаданные.Справочники[ТекИмяОбъекта].Реквизиты.Найти(ТекИмяРеквизита);
			Если НайденныйРеквизит <> Неопределено Тогда
				ТекМаска = НайденныйРеквизит.Маска;
			Иначе	
				ТекМаска = Метаданные.Справочники[ТекИмяОбъекта].СтандартныеРеквизиты[ТекИмяРеквизита].Маска;
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЕсли;
	
	Возврат ТекМаска;

КонецФункции // ЗаполнитьМаскуКодаПоУмолчанию()

// Функция получает порядок кода.
// 
// Параметры:
//  МаскаКода  - Строка
//  Код  	   - Строка
//  
// Возвращаемое значение:
//   Строка
// 
Функция ПолучитьПорядокКодаПоМаскеКода(МаскаКода, Код) Экспорт

	ПорядокКода = "";
	
	МассивРазделителей = бит_БухгалтерияКлиентСервер.ПолучитьМассивДоступныхРазделителейМасокПлановСчетов();
	слРазделитель 	   = "Разделитель";
				
	МкКоличествоРазделителей = бит_БухгалтерияКлиентСервер.ПолучитьКоличествоРазделителейМаски(МаскаКода, МассивРазделителей);
	      	
	ИзмененнаяМаска = МаскаКода;
	ИзмененныйКод = Код;
	Для каждого ТекРазделитель Из МассивРазделителей Цикл
		ИзмененнаяМаска = ДобавитьСлужебныйРазделитель(ИзмененнаяМаска, слРазделитель, ТекРазделитель);		
		ИзмененныйКод   = ДобавитьСлужебныйРазделитель(ИзмененныйКод  , слРазделитель, ТекРазделитель);
	КонецЦикла;
	ИзмененнаяМаска = ДобавитьСлужебныйРазделитель(ИзмененнаяМаска, слРазделитель, слРазделитель + слРазделитель);
	ИзмененныйКод   = ДобавитьСлужебныйРазделитель(ИзмененныйКод  , слРазделитель, слРазделитель + слРазделитель);
             	
	МассивКода  = бит_СтрокиКлиентСервер.РазобратьСтрокуСРазделителями(ИзмененныйКод  , слРазделитель);	
	МассивМаски = бит_СтрокиКлиентСервер.РазобратьСтрокуСРазделителями(ИзмененнаяМаска, слРазделитель);
	КоличествоГруппМаски = МассивМаски.Количество();
	
	
	Сч = 0;
	Для каждого ГруппаКода Из МассивКода Цикл
				  		
		Если КоличествоГруппМаски > Сч Тогда
			
			ГруппаМаски = МассивМаски[Сч];
			
			ЭтоРазделительГрКд = бит_БухгалтерияКлиентСервер.ПолучитьКоличествоРазделителейМаски(ГруппаКода)  = 1;
			ЭтоРазделительГрМк = бит_БухгалтерияКлиентСервер.ПолучитьКоличествоРазделителейМаски(ГруппаМаски) = 1;
			
			Если ЭтоРазделительГрКд И ЭтоРазделительГрМк Тогда
				ПорядокКода = ПорядокКода + ГруппаМаски;
			ИначеЕсли ЭтоРазделительГрКд И Не ЭтоРазделительГрМк Тогда	
			    ПорядокКода = ПорядокКода + ГруппаМаски + ГруппаКода;
				Сч = Сч + 1;
			ИначеЕсли Не ЭтоРазделительГрКд И ЭтоРазделительГрМк Тогда
				ПорядокКода = ПорядокКода + ГруппаМаски;
				Сч = Сч + 1;
				ГруппаМаски = МассивМаски[Сч];
				ДобавитьГруппуКодаПоМаске(ПорядокКода, ГруппаКода, ГруппаМаски);
			Иначе
				ДобавитьГруппуКодаПоМаске(ПорядокКода, ГруппаКода, ГруппаМаски);
			КонецЕсли;	
		
		КонецЕсли;
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
	// Изменение кода. Начало. 10.04.2014{{
	ПорядокКода = СокрЛП(ПорядокКода);
	// Изменение кода. Конец. 10.04.2014}}
	
	Возврат ПорядокКода;
	
КонецФункции // ПолучитьПорядокКодаПоМаскеКода()
 
// Процедура преобразует код, код родителя и порядок по маске кода.
// 
// Параметры:
//  Данные    - Структура
//  МаскаКода - Строка
// 
Процедура ПреобразоватьДанныеПоМаскеКода(Данные, МаскаКода) Экспорт
	
	ДлинаМаски = СтрДлина(МаскаКода);
	
	ТекущийКод   	   = Данные.Код;
	ТекущийПорядок     = Данные.Порядок;
	ТекущийКодРодитель = Данные.РодительКод;
	
	ЧистыйКод    = СокрЛП(бит_БухгалтерияКлиентСервер.УдалитьРазделителиИзСтроки(ТекущийКод));
	ДлинаЧистого = СтрДлина(ЧистыйКод); 			
	НовыйКод  = "";
	НомерЗнч  = 1;
	
	ЧистыйКодРодитель    = СокрЛП(бит_БухгалтерияКлиентСервер.УдалитьРазделителиИзСтроки(ТекущийКодРодитель)); 
	ДлинаЧистогоРодитель = СтрДлина(ЧистыйКодРодитель);
	НовыйКодРодитель  = "";
	НомерЗнчРодитель  = 1;
	
	// Если ДлинаЧистого > МаскаКоличествоЗначимых Тогда
	// 	Продолжить;			
	// КонецЕсли;
	
	Для Ст = 1 По ДлинаМаски Цикл
		
		ТекСимволМаски = Сред(МаскаКода, Ст, 1);
		Если ТекСимволМаски = "@" Тогда
			
			ТекущийСимвол 			= Сред(ЧистыйКод, НомерЗнч, 1); 
			НовыйКод 				= НовыйКод + ТекущийСимвол;
			
			ТекущийСимволРодитель 	= Сред(ЧистыйКодРодитель, НомерЗнчРодитель, 1);
			НовыйКодРодитель 		= НовыйКодРодитель + ТекущийСимволРодитель;
			
			НомерЗнч 				= НомерЗнч + 1;
			НомерЗнчРодитель 		= НомерЗнчРодитель + 1;
			
		Иначе
			Если ДлинаЧистого >= НомерЗнч Тогда 
				НовыйКод = НовыйКод + ТекСимволМаски;
			КонецЕсли;
			Если ДлинаЧистогоРодитель >= НомерЗнчРодитель Тогда 
				НовыйКодРодитель = НовыйКодРодитель + ТекСимволМаски;
			КонецЕсли;
		КонецЕсли;
					
	КонецЦикла;
	
	Данные.Код 			= СокрЛп(НовыйКод);
	Данные.РодительКод 	= СокрЛп(НовыйКодРодитель);
	Данные.Порядок		= ПолучитьПорядокКодаПоМаскеКода(МаскаКода, НовыйКод);

КонецПроцедуры // ПреобразоватьДанныеПоМаскеКода()

// Процедура заполняет кодификатор.
// 
Процедура ЗаполнитьКодификаторДляЭлементаСправочника(ДанныеЗаполнения, Ссылка, Кодификатор) Экспорт

	ЗаполнятьПоУмолчанию = Ложь;
	
	МетаСпр 	   = Ссылка.Метаданные();
	ИмяСправочника = МетаСпр.Имя;
	
	ТекОбъектСистемы  = бит_УправлениеОбъектамиСистемы.НайтиОбъектДоступаПоТипу(ТипЗнч(Ссылка), Перечисления.бит_ВидыОбъектовСистемы.Справочник);
	МаскаКодификатора = РегистрыСведений.бит_МаскиКодов.ПолучитьМаскуРеквизита(ТекОбъектСистемы, "Кодификатор", ЗаполнятьПоУмолчанию);
	
	Если МаскаКодификатора = "" Или Не ЗаполнятьПоУмолчанию Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ДанныеЗаполнения.Свойство("Родитель") И ЗначениеЗаполнено(ДанныеЗаполнения.Родитель) Тогда
		ГруппаРодитель = ДанныеЗаполнения.Родитель;
	 	Кодификатор    = ГруппаРодитель.Кодификатор;	
	Иначе
		ГруппаРодитель = Справочники[ИмяСправочника].ПустаяСсылка();
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель", ГруппаРодитель);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СУММА(1) КАК КоличествоЭлементов
	|ИЗ
	|	Справочник." + ИмяСправочника + " КАК ТекСпр
	|ГДЕ
	|	ТекСпр.Родитель = &Родитель
	|";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ПорядковыйНомер = "1";
	Иначе	
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ПорядковыйНомер = ?(Выборка.КоличествоЭлементов = Null, "1", Строка(Выборка.КоличествоЭлементов + 1));
	КонецЕсли;
	
	МассивРазделителей = бит_БухгалтерияКлиентСервер.ПолучитьМассивДоступныхРазделителейМасокПлановСчетов();
	МассивМаски = бит_СтрокиКлиентСервер.РазобратьСтрокуСМассивомРазделителей(МаскаКодификатора, МассивРазделителей);
	МассивКодиф = бит_СтрокиКлиентСервер.РазобратьСтрокуСМассивомРазделителей(Кодификатор	   , МассивРазделителей);
	
	// Поиск номера раздела, куда нужно вставить новый ПорядковыйНомер.
	Если ПустаяСтрока(Кодификатор) Тогда
		
		НомерРаздела = 0;		
	
	Иначе
		
		НомерРаздела = Неопределено;  	
		КоличествоРазделовМаски  = МассивМаски.Количество();
		КоличествоРазделовГруппы = МассивКодиф.Количество();
		Если КоличествоРазделовГруппы < КоличествоРазделовМаски Тогда
	     	НомерРаздела = КоличествоРазделовГруппы;
		ИначеЕсли КоличествоРазделовГруппы = КоличествоРазделовМаски Тогда
			Для Сч = 1 По КоличествоРазделовМаски Цикл
				ЧислоСч = КоличествоРазделовМаски - Сч;
			 	ЭлКод = МассивКодиф[ЧислоСч];
				Если ПустаяСтрока(СокрЛП(ЭлКод)) Тогда
			     	НомерРаздела = ЧислоСч;
				Иначе
					Прервать;	
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	
	КонецЕсли;
	
	Если НомерРаздела = Неопределено Тогда
    	Возврат;		
	КонецЕсли;
	
	ДлинаРаздела     = СтрДлина(МассивМаски[НомерРаздела]);
	ДлинаПорядкового = СтрДлина(ПорядковыйНомер);
	Если ДлинаРаздела < ДлинаПорядкового Тогда
    	Возврат;		
	ИначеЕсли ДлинаРаздела > ДлинаПорядкового Тогда
		Для Сч = ДлинаПорядкового + 1 По ДлинаРаздела Цикл
		 	ПорядковыйНомер = "0" + ПорядковыйНомер;	
		КонецЦикла;
	КонецЕсли;
	
	// Длина кодификатора группы
	КолСимволовГруппы = 0;
	Для Сч = 0 По НомерРаздела - 1 Цикл
     	КолСимволовГруппы = КолСимволовГруппы + СтрДлина(МассивМаски[Сч]) + 1;
	КонецЦикла;
	Если КолСимволовГруппы - 1 > СтрДлина(Кодификатор) Тогда
		Для Сч = СтрДлина(Кодификатор) + 1 По КолСимволовГруппы - 1 Цикл
		 	Кодификатор = Кодификатор + " ";	
		КонецЦикла;
	КонецЕсли;

	СимволРазделитель = ?(КолСимволовГруппы = 0, "", Сред(МаскаКодификатора, КолСимволовГруппы, 1));
	Кодификатор = Лев(Кодификатор, КолСимволовГруппы) + СимволРазделитель + ПорядковыйНомер;
		
КонецПроцедуры // ЗаполнитьКодификатор()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет группу символов к порядку кода.
// 
// Параметры:
//  ПорядокКода - Строка
//  ГруппаКода  - Строка
//  ГруппаМаски - Строка
// 
Процедура ДобавитьГруппуКодаПоМаске(ПорядокКода, ГруппаКода, ГруппаМаски)

	КоличествоПробелов = СтрДлина(ГруппаМаски) - СтрДлина(ГруппаКода);
	
	// Добавим пробелы слева
	Если КоличествоПробелов > 0 Тогда
		Для i = 1 по КоличествоПробелов Цикл
			ПорядокКода = ПорядокКода + " ";
		КонецЦикла;
	КонецЕсли;
	
	ПорядокКода = ПорядокКода + ГруппаКода;

КонецПроцедуры // ДобавитьГруппуКодаПоМаске()

// Процедура добавляет разделитель в строку.
// 
// Параметры:
//  ИсходнаяСтрока   - Строка
//  Разделитель      - Строка
//  ВыделяемыйСимвол - Строка
// 
// Возвращаемое значение:
//   Строка
// 
Функция ДобавитьСлужебныйРазделитель(ИсходнаяСтрока, слРазделитель, ВыделяемыйСимвол)

	ИзменяемаяСтрока = СтрЗаменить(ИсходнаяСтрока
								, ВыделяемыйСимвол
								, слРазделитель + ВыделяемыйСимвол + слРазделитель);	

	Возврат ИзменяемаяСтрока;
	
КонецФункции // ДобавитьСлужебныйРазделитель()

#КонецОбласти

#КонецЕсли
