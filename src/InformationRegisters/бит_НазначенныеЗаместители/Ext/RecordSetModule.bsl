#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
    
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	
	Для каждого эо Из ЭтотОбъект.Отбор Цикл
	
		Запрос.УстановитьПараметр(эо.Имя, эо.Значение);
	
	КонецЦикла; 
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_НазначенныеЗаместители.Пользователь,
	               |	бит_НазначенныеЗаместители.Состояние,
	               |	бит_НазначенныеЗаместители.Виза,
	               |	бит_НазначенныеЗаместители.РольИсполнителя,
	               |	бит_НазначенныеЗаместители.ПользовательскоеУсловие,
	               |	бит_НазначенныеЗаместители.ОбъектАдресации_1,
	               |	бит_НазначенныеЗаместители.ОбъектАдресации_2,
	               |	бит_НазначенныеЗаместители.ОбъектАдресации_3,
	               |	бит_НазначенныеЗаместители.Заместитель,
	               |	бит_НазначенныеЗаместители.ДатаНачала,
	               |	бит_НазначенныеЗаместители.ДатаОкончания,
	               |	бит_НазначенныеЗаместители.ПередаватьПраваРЛС
	               |ИЗ
	               |	РегистрСведений.бит_НазначенныеЗаместители КАК бит_НазначенныеЗаместители
	               |ГДЕ
	               |	бит_НазначенныеЗаместители.Пользователь = &Пользователь
	               |	И бит_НазначенныеЗаместители.Состояние = &Состояние
	               |	И бит_НазначенныеЗаместители.Виза = &Виза
	               |	И бит_НазначенныеЗаместители.РольИсполнителя = &РольИсполнителя
	               |	И бит_НазначенныеЗаместители.ОбъектАдресации_1 = &ОбъектАдресации_1
	               |	И бит_НазначенныеЗаместители.ОбъектАдресации_2 = &ОбъектАдресации_2
	               |	И бит_НазначенныеЗаместители.ОбъектАдресации_3 = &ОбъектАдресации_3
	               |	И бит_НазначенныеЗаместители.Заместитель = &Заместитель
	               |	И бит_НазначенныеЗаместители.ПользовательскоеУсловие = &ПользовательскоеУсловие";
				   
	ТаблицаКонтроль = Запрос.Выполнить().Выгрузить();
	ЭтотОбъект.ДополнительныеСвойства.Вставить("ТаблицаКонтроль", ТаблицаКонтроль);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда	
		Возврат;	
	КонецЕсли; 	
	
	Если ЭтотОбъект.Количество() = 0 
		 И ЭтотОбъект.ДополнительныеСвойства.Свойство("ТаблицаКонтроль") 
		 И ЭтотОбъект.ДополнительныеСвойства.ТаблицаКонтроль.Количество() > 0 Тогда
	
		 // Выполнено удаление - необходимо удалить заместителей из регистров.
		 Для каждого СтрокаТаблицы Из ЭтотОбъект.ДополнительныеСвойства.ТаблицаКонтроль Цикл
			 
			 СтрПар = РегистрыСведений.бит_НазначенныеЗаместители.КонструкторПараметрыНазначенияЗаместителя();
			 ЗаполнитьЗначенияСвойств(СтрПар, СтрокаТаблицы);
			 
			 РегистрыСведений.бит_НазначенныеЗаместители.УдалитьНазначениеЗаместителей(СтрПар);
		 
		 КонецЦикла; 
	
	КонецЕсли; 
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		СтрПар = РегистрыСведений.бит_НазначенныеЗаместители.КонструкторПараметрыНазначенияЗаместителя();
		ЗаполнитьЗначенияСвойств(СтрПар, Запись);
		
		Если Запись.Состояние = Перечисления.бит_СостоянияЗаместителей.Назначен Тогда
			
			// Назначаем заместителя, если он еще не назначен.
			РегистрыСведений.бит_НазначенныеЗаместители.НазначитьЗаместителя(СтрПар);
			
		ИначеЕсли Запись.Состояние = Перечисления.бит_СостоянияЗаместителей.ЗамещениеЗавершено Тогда	
			
			РегистрыСведений.бит_НазначенныеЗаместители.УдалитьНазначениеЗаместителей(СтрПар);
						
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
